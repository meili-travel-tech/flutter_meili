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
-   Android Version: As per your project's minimum SDK requirements

#### iOS

Compatible with apps targeting iOS 16 or above.

Update your iOS deployment target to 13.0 in your `project.pbxproj` or via Xcode under Build Settings.

Update your `Podfile`:

```ruby
platform :ios, '16.0'
```

## Usage

### Card payments

There are 3 ways of handling card payments

| Method               | Ease of use | description                                                            | Implementation docs                                                                           |
| -------------------- | ----------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Meili Sheet View     | Easy        | It opens a sheet view screen rendering the Meili Flow                  | [Meili Support](https://meili.atlassian.net/servicedesk/customer/portal/1/article/1304231937) |
| Meili Connect Widget | Easy        | Native flutter widget to be embedded together any other flutter widget | [Meili Support](https://meili.atlassian.net/servicedesk/customer/portal/1/article/1304231937) |

#### Meili Direct

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

#### Meili Booking Manager

To open the Meili view for the direct flow, use the following code snippet:

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

#### Meili Connect

To use the MeiliConnectWidget, integrate it into your widget tree with the necessary parameters:

```dart
import 'package:flutter/material.dart';
import 'package:meili_flutter/meili_flutter.dart';

MeiliConnectWidget(
  ptid: "ptid",
  env: "uat",
  availParams: AvailParams(
    pickupLocation: "BCN",
    dropoffLocation: "BCN",
    pickupDateTime: DateTime.parse("2024-08-19T14:38:34.301Z"),
    dropoffDateTime: DateTime.parse("2024-08-28T14:38:34.301Z"),
    driverAge: 25,
    currencyCode: "EUR",
    residency: "IE",
  )
);
```

## Error Handling

If an error occurs while attempting to open the Meili view, a `PlatformException` will be thrown, and an error message will be printed to the console.

## Platform Support

### iOS

The Meili view is supported on iOS. The `MethodChannel` for iOS is `meili_flutter_ios`.

### Android

The Meili view is currently not supported on Android. Attempting to open the Meili view on Android will result in a `PlatformException` with the message "Android platform view is not yet supported".

## Contributing

You can help us make this project better by opening new issues or pull requests.
