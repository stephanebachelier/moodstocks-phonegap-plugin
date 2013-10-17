# Moodstocks SDK - PhoneGap Plugins

This is the working-in-progress branch for supporting PhoneGap 3.0. Please don't
use it until we fully merge it to the master branch.

## Setting up with Cordova 3.0+

### Using Cordova CLI

Here we suppose you are already using the [Cordova CLI (command line interface)](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface) and familiar with its basic commands.

1. Create a HelloWorld project for iOS platform
```console
phonegap create hello com.example.hello HelloWorld
cd hello
phonegap platform add ios
```

2. Clone the [Moodstocks Phonegap plugin repo](https://github.com/Moodstocks/moodstocks-phonegap-plugin)
```console
git clone https://github.com/Moodstocks/moodstocks-phonegap-plugin
```

3. Checkout the [phonegap3 branch](https://github.com/Moodstocks/moodstocks-phonegap-plugin/tree/phonegap3)
```console
git checkout phonegap3
```

4. Add the plugin to your project
```
phonegap local plugin add <PATH TO THE CLONED PLUGIN REPO>`
```

5. Build your iOS app to generate the XCode project:
```console
phonegap build ios
```

6. Open your project in Xcode
```console
open platforms/ios/HelloWorld.xcodeproj/
```

7. [Setup Moodstocks SDK for iOS](https://developers.moodstocks.com/doc/tuto-ios/1)

Now you can start using MoodstocksPlugin in your project!

## References

* [Plugin Spec](http://docs.phonegap.com/en/edge/guide_plugins_plugin_spec.md.html#Plugin%20Specification)

## Help

Need help? Check out our [Help Center](http://help.moodstocks.com/).

## Copyright

Copyright (c) 2013 [Moodstocks SAS](http://www.moodstocks.com)
