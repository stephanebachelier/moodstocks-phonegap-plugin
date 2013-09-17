# Moodstocks SDK - PhoneGap Plugins

This is the working-in-progress branch for supporting PhoneGap 3.0. Please don't
use it until we fully merge it to the master branch.

## Setup

First you need to download the SDK through [your developer account](https://developers.moodstocks.com/apps).

### iOS
1. Clone the plugin from the [github repo](https://github.com/Moodstocks/moodstocks-phonegap-plugin).
2. Checkout the [phonegap3 branch](https://github.com/Moodstocks/moodstocks-phonegap-plugin/tree/phonegap3).
3. Add the plugin to your project using the cordova command:  
`cordova plugin add <PATH TO THE CLONED PLUGIN REPO>`
4. Reconfigure the Xcode project using the command:  
`cordova prepare`
5. Add the cordova sdk files to your Xcode project (including `libmoodstocks-sdk.a`).
  * Don't just copy the files in the folder, link them in the project.
6. Add the following frameworks to your project in `Build Phases > Link Binary With Libraries`:
  * `CoreMedia.framework`
  * `AVFoundation.framework`
  * `CoreVideo.framework`
  * `QuartzCore.framework`
7. If necessary, disable [ARC](http://en.wikipedia.org/wiki/Automatic_Reference_Counting) for the moodstocks plugin files.
  * In `Build Phases > Compile Sources`, add the `-fno-objc-arc` compiler flag to the following files:
     * `MoodstocksPlugin.m`
     * `MSHandler.m`
     * `MSScannerController.m`
8. You're done !

## Help

Need help? Check out our [Help Center](http://help.moodstocks.com/).

## Copyright

Copyright (c) 2013 [Moodstocks SAS](http://www.moodstocks.com)
