# Moodstocks SDK - PhoneGap Plugins

This is the working-in-progress branch for supporting PhoneGap 3.0. Please don't
use it until we fully merge it to the master branch.

## Setting up using Cordova CLI

Here we suppose you've already been using the [PhoneGap CLI (command line interface)](http://docs.phonegap.com/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface) and familiar with its basic commands.

* Create a HelloMS project
```console
phonegap create helloms com.example.helloms HelloMS
cd helloms
```

* Clone the [Moodstocks Phonegap plugin repo](https://github.com/Moodstocks/moodstocks-phonegap-plugin)
```console
git clone https://github.com/Moodstocks/moodstocks-phonegap-plugin
```

* Checkout the [phonegap3 branch](https://github.com/Moodstocks/moodstocks-phonegap-plugin/tree/phonegap3)
```console
git checkout phonegap3
```

* Add the plugin to your project
```
phonegap local plugin add <PATH TO THE CLONED PLUGIN REPO>`
```

### iOS

* Build your project for iOS platform:
```console
phonegap build ios
```

* Open your project in Xcode
```console
open platforms/ios/HelloMS.xcodeproj/
```

* [Setup Moodstocks SDK for iOS](https://moodstocks.com/documentation/user-guides/ios-guide/#setup)

Now you can start using MoodstocksPlugin in your project!

### Android

* Build your project for Android platform:
```console
phonegap build android
```

* Import your project in your Android development IDE

* Open `MoodstocksScanActivity.java` in package `com.moodstocks.phonegap.plugin`
and import the `R` class of your `HelloMS` project - `com.example.helloms.R`.

* Open `HelloMS.java` in package `com.example.helloms` package and add this
piece of code in your activity:

```Java
public class HelloMS extends DroidGap {

  //...
  private boolean scanActivityStarted = false;

  @Override
  public void init() {
    MoodstocksWebView webView = new MoodstocksWebView(HelloMS.this);
      CordovaWebViewClient webViewClient;

      if(android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.HONEYCOMB) {
          webViewClient = new CordovaWebViewClient(this, webView);
      }
      else {
          webViewClient = new IceCreamCordovaWebViewClient(this, webView);
      }

      this.init(webView, webViewClient, new CordovaChromeClient(this, webView));
  }

  @Override
  public void onPause() {
    super.onPause();

    // Remove the web view from the root view when we launch the Moodstocks scanner
    if (scanActivityStarted) {
      super.root.removeView(super.appView);
    }
  }

  @Override
  public void onResume() {
    super.onResume();

    // this case is occurred when the scanActivity fails at launching
    // the failure of launching scanner is often caused by the camera's unavailability
    // in this case we retrieve & reload the web view before inserting it back
    if (scanActivityStarted && (super.appView.getParent() != null)) {
      ((ViewManager)super.appView.getParent()).removeView(super.appView);
      super.appView.reload();
    }

    // Reset the web view to root container when we dismiss the Moodstocks scanner
    if (scanActivityStarted && (super.appView.getParent() == null)) {
      super.root.addView(super.appView);
      scanActivityStarted = false;
    }
  }

  @Override
  public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {
    // If the intent indicate the upcoming activity is a Moodtsocks scan activity
    // We will launch the activity and keep the js/native code running on the background
    if (intent.getExtras().getString("com.moodstocks.phonegap.plugin") != null) {
      if(intent.getExtras().getString("com.moodstocks.phonegap.plugin").equals("MoodstocksScanActivity")) {
        scanActivityStarted = true;
        this.startActivityForResult(intent, requestCode);
      }
    }
    else {
      super.startActivityForResult(command, intent, requestCode);
    }
  }
}
```

* [Setup Moodstocks SDK for Android](https://moodstocks.com/documentation/user-guides/android-guide/#setup)

## References

* [Plugin Spec](http://docs.phonegap.com/en/edge/guide_plugins_plugin_spec.md.html#Plugin%20Specification)

## Help

Need help? Check out our [Help Center](http://help.moodstocks.com/).

## Copyright

Copyright (c) 2013 [Moodstocks SAS](http://www.moodstocks.com)
