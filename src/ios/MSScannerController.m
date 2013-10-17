/**
 * Copyright (c) 2013 Moodstocks SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MSScannerController.h"

#import "MSDebug.h"
#import "MSImage.h"

#include "moodstocks_sdk.h"

@interface MSScannerController ()
- (void)layoutCaptureVideoPreviewLayer;
@end

@implementation MSScannerController

- (id)initWithHandler:(MSHandler *)handler
          scanOptions:(NSInteger)scanOptions
 useDeviceOrientation:(BOOL)useDeviceOrientation
    noPartialMatching:(BOOL)noPartialMatching
   smallTargetSupport:(BOOL)smallTargetSupport
               plugin:(MoodstocksPlugin *)plugin {
    self = [super init];

    if (self) {
        self.handler = handler;
        _scanOptions = scanOptions;

        _scannerSession = [[MSScannerSession alloc] initWithScanner:[MSScanner sharedInstance]];
#if MS_SDK_REQUIREMENTS
        [_scannerSession setScanOptions:_scanOptions];
        [_scannerSession setDelegate:self];

        [_scannerSession setUseDeviceOrientation:useDeviceOrientation];
        [_scannerSession setNoPartialMatching:noPartialMatching];
        [_scannerSession setSmallTargetSupport:smallTargetSupport];

        _plugin = plugin;
#endif
    }

    return self;
}

- (void)dealloc {
    [super dealloc];

    [_scannerSession release];
    self.result = nil;
    self.handler = nil;
}

- (void)loadView {
    [super loadView];

    CGRect videoFrame = [[UIScreen mainScreen] bounds];
    _videoPreview = [[[UIView alloc] initWithFrame:videoFrame] autorelease];
    _videoPreview.backgroundColor = [UIColor blackColor];
    _videoPreview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _videoPreview.autoresizesSubviews = YES;
    [self.view addSubview:_videoPreview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = nil;

    CALayer *videoPreviewLayer = [_videoPreview layer];
    [videoPreviewLayer setMasksToBounds:YES];
    
    // force preview layer orientation to device orientation
    AVCaptureVideoPreviewLayer *captureLayer = (AVCaptureVideoPreviewLayer *)[_scannerSession previewLayer];
    [captureLayer layoutSublayers];
    captureLayer.frame = self.view.bounds;
    
    // update video orientation
    [[captureLayer connection] setVideoOrientation:[[UIDevice currentDevice] orientation]];
    
    [videoPreviewLayer insertSublayer:captureLayer below:[[videoPreviewLayer sublayers] objectAtIndex:0]];

    _toolbar = [[[UIToolbar alloc] init] autorelease];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _toolbar.barStyle = UIBarStyleBlack;
    _toolbar.tintColor = nil;

    _barButton = [[[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                   target:self
                   action:@selector(dismissAction)] autorelease];

    id flexSpace = [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil
                    action:nil] autorelease];

    _toolbar.items = [NSArray arrayWithObjects:_barButton,flexSpace,nil];
    [_toolbar sizeToFit];
    CGFloat toolbarHeight = _toolbar.frame.size.height;
    CGFloat rootViewWidth = CGRectGetWidth(self.view.bounds);
    CGRect rectArea = CGRectMake(0, 0, rootViewWidth, toolbarHeight);
    [_toolbar setFrame:rectArea];

    [self.view addSubview:_toolbar];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_scannerSession startCapture];
}

- (void)viewWillLayoutSubviews
{
    [self layoutCaptureVideoPreviewLayer];
}

#pragma mark -
#pragma mark Autorotation setting

// IOS 6
- (BOOL)shouldAutorotate {
    return self.presentingViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.presentingViewController.supportedInterfaceOrientations;
}

// IOS < 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    [CATransaction begin];
    [self layoutCaptureVideoPreviewLayer];
    [CATransaction commit];
    
    [super willAnimateRotationToInterfaceOrientation:orientation duration:duration];
}

- (void)layoutCaptureVideoPreviewLayer
{
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = (AVCaptureVideoPreviewLayer *)[_scannerSession previewLayer];
    
    captureVideoPreviewLayer.frame = self.view.bounds;
    [captureVideoPreviewLayer layoutSublayers];
    
    // update video orientation
    [[captureVideoPreviewLayer connection] setVideoOrientation:[self captureVideoOrientation]];
}

- (AVCaptureVideoOrientation)captureVideoOrientation
{
    AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation == UIDeviceOrientationPortrait)
        orientation = AVCaptureVideoOrientationPortrait;
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        orientation = AVCaptureVideoOrientationPortraitUpsideDown;
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        orientation = AVCaptureVideoOrientationLandscapeRight;
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        orientation = AVCaptureVideoOrientationLandscapeLeft;
    
    return orientation;
}

#pragma mark

- (void)pause {
    [_scannerSession pause];
}

- (void)resume {
    self.result = nil;
    [_scannerSession resume];
}

- (void)dismissAction {
    [_scannerSession stopCapture];
    [_scannerSession cancel];

    [self.handler scanDismissed];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - MSScannerSessionDelegate

#if MS_SDK_REQUIREMENTS
- (void)session:(MSScannerSession *)scanner didScan:(MSResult *)result {
    if (result != nil){
        if (![self.result isEqualToResult:result]) {
            self.result = nil;
            self.result = result;

            [self pause];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.handler scanResultFound:[result getValue] format:[result getType]];
            });
        }
    }
}

- (void)session:(MSScannerSession *)scanner failedToScan:(NSError *)error {
    MSDLog(@" [MOODSTOCKS SDK] SCAN ERROR: %@", MSErrMsg([error code]));
}

#endif

@end
