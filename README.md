# Moodstocks SDK - PhoneGap Plugins

Moodstocks PhoneGap plugins helps you to integrate Moodstocks SDK in your
PhoneGap application. We provide iOS and Android version tested with PhoneGap
v.2.3.0 ~ v.3.3.0.

## Real-time on-device image recognition SDK

The Moodstocks SDK provides a scanner for mobile devices. It recognizes both
barcodes and images. Scanning operates on the client-side which lets you create
nice augmented reality overlays. Also it even works off-line thanks to a built-in,
easy-to-use on-device image signatures synchronization.

## Repository structure
```
├── src
│   ├── android
│   │   ├── Demo.java
│   │   ├── MoodstocksPlugin.java
│   │   ├── MoodstocksScanActivity.java
│   │   ├── MoodstocksWebView.java
│   │   └── scan.xml
│   └── ios
│       ├── MSHandler.h
│       ├── MSHandler.m
│       ├── MSScannerController.h
│       ├── MSScannerController.m
│       ├── MoodstocksAPI.h
│       ├── MoodstocksPlugin.h
│       └── MoodstocksPlugin.m
├── www
│   └── MoodstocksPlugin.js
├── plugin.xml
```

* `src/android`: Android plugin source files
* `src/ios`: iOS plugin source files
* `www/MoodstocksPlugin.js`: Plugin javascript interface
* `plugin.xml`: Plugin specification

## Step-by-Step User Guide

Follow our [Getting Started Guide](https://moodstocks.com/documentation/getting-started/phonegap/) to get Moodstocks PhoneGap plugin working in your project!

## Copyright

Copyright (c) 2014 [Moodstocks SAS](http://www.moodstocks.com)
