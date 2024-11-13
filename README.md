# Meili Flutter Plugin

[![pub package](https://img.shields.io/pub/v/meili_flutter.svg)](https://pub.dev/packages/meili_flutter)

The Meili Flutter Plugin allows you to integrate the Meili experience into your Flutter applications.

## Features

**Cross-Platform Support**: The Meili plugin supports both iOS and Android platforms.

**Customizable UI**: Provides powerful and customizable UI screens and elements to collect user details.

**Direct Integration**: Directly integrates with Meili for a seamless user experience.

**Platform Specific Implementation**: Different implementations for iOS and Android, ensuring optimal performance on each platform.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
    meili_flutter: ^1.0.0
```

Run `flutter pub get` to install the package.

### Requirements

-   iOS Version: 16.0 or higher
    -   Add the meili CocoaPods repository `source https://github.com/meili-travel-tech/meili-ios-pods` to your Podfile project.
    -   Run `pod repo update && pod install` in the ios directory.
    -   If you find any issues, also try to clean up the cache of the pub-cache and Pods already installed.
-   Android Version: As per your project's minimum SDK requirements

#### iOS - Steps

Compatible with apps targeting iOS 16 or above.

Update your iOS deployment target to 13.0 in your `project.pbxproj` or via Xcode under Build Settings.

Update your `Podfile`:

```ruby
source 'https://github.com/meili-travel-tech/meili-ios-pods'

platform :ios, '16.0'
```

## Usage

There are 3 Meili views that are supported

| Flow                  | Ease of use | description                                                                                  | Implementation docs                                                                           |
| --------------------- | ----------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Meili Direct          | Easy        | Opens a sheet view screen rendering the Meili Direct Flow                                    | [Meili Support](https://meili.atlassian.net/servicedesk/customer/portal/1/article/1304231937) |
| Meili Booking Manager | Easy        | Opens a sheet view screen rendering the Meili Booking Manager Flow                           | [Meili Support](https://meili.atlassian.net/servicedesk/customer/portal/1/article/1304231937) |
| Meili Connect Widget  | Easy        | Native flutter widget that renders the Meili Connect Flow to be embedded in a flutter widget | [Meili Support](https://meili.atlassian.net/servicedesk/customer/portal/1/article/1304231937) |

### Meili Direct

To open the Meili view for the direct flow, use the following code snippet:

```dart
import 'package:meili_flutter/meili_flutter.dart';

void _openMeiliView() async {
    final params = MeiliParams(
      ptid: 'ptid',
      currentFlow: FlowType.direct,
      env: 'dev',
    );

    try {
      await Meili.openMeiliView(params);
    } catch (e) {
      print("Failed to open MeiliView: $e");
    }
  }
```

### Meili Booking Manager

To open the Meili view for the booking manager flow, use the following code snippet:

```dart
import 'package:meili_flutter/meili_flutter.dart';

void _openMeiliView() async {
    final params = MeiliParams(
      ptid: 'ptid',
      currentFlow: FlowType.bookingManager,
      env: 'dev',
      // you can pass the values to prefill the fields
      // it will search automatically once the flow is opened
      bookingParams: BookingParams(
        confirmationId: "1234ABCD",
        lastName: "Doe"
      )

    );

    try {
      await Meili.openMeiliView(params);
    } catch (e) {
      print("Failed to open MeiliView: $e");
    }
  }
```

### Meili Connect

To use the MeiliConnectWidget, integrate it into your widget tree with the necessary parameters:

```dart
import 'package:flutter/material.dart';
import 'package:meili_flutter/meili_flutter.dart';

MeiliConnectWidget(
  ptid: 'ptid',
  env: 'prod',
  availParams: AvailParams(
    pickupLocation: 'MUC',
    dropoffLocation: 'MUC',
    pickupDate: '2025-01-01',
    pickupTime: '12:00',
    dropoffDate: '2025-01-07',
    dropoffTime: '12:00',
    driverAge: 25,
    currencyCode: 'EUR',
    residency: 'IE',
  ),
)
```

## Error Handling

If an error occurs while attempting to open the Meili view, a `PlatformException` will be thrown, and an error message will be printed to the console.

## Platform Support

### iOS

The Meili view is supported on iOS. The `MethodChannel` for iOS is `meili_flutter_ios`.

### Android

We are working to integrate the Meili Android SDK into the Meili Flutter plugin. Support for the Meili view on Android will be available very soon. In the meantime, attempting to open the Meili view on Android may result in a PlatformException with the message "Android platform view is not yet supported".

## Contributing

You can help us make this project better by opening new issues or pull requests.
