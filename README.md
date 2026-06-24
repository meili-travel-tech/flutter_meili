# Meili Flutter Plugin

[![pub package](https://img.shields.io/pub/v/meili_flutter.svg)](https://pub.dev/packages/meili_flutter)

The Meili Flutter Plugin allows you to integrate the Meili car rental booking experience into your Flutter applications on both iOS and Android.

## Features

- **Cross-platform**: Full support for iOS and Android
- **Two booking flows**: Direct (search & book) and Booking Manager (manage existing bookings)
- **Dismiss callback**: Listen for when the user closes the Meili flow
- **Prefill support**: Pass availability and booking parameters to pre-populate the search

## Requirements

| Platform | Minimum version |
|----------|----------------|
| iOS      | 16.0           |
| Android  | API 27         |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  meili_flutter: ^0.3.1-beta.4
```

Run:
```bash
flutter pub get
```

### Android setup

The Android SDK is served from a public Maven repository over GitHub Pages, so **no credentials are required**. Add the repository to your **project-level** `android/build.gradle`:

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://meili-travel-tech.github.io/ux-native-android/") }
    }
}
```

### iOS setup

Add the Meili CocoaPods source to your `ios/Podfile`:

```ruby
source 'https://github.com/meili-travel-tech/meili-ios-pods'
source 'https://cdn.cocoapods.org/'

platform :ios, '16.0'
```

Then run:
```bash
cd ios && pod repo update && pod install
```

## Usage

### MeiliView widget (recommended)

Embed the Meili flow directly as a widget — typically full screen:

```dart
import 'package:flutter/material.dart';
import 'package:meili_flutter/meili_flutter.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => MeiliView(
          ptid: 'your-ptid',
          env: 'prod', // 'dev', 'uat', 'pre_prod', 'prod'
          flow: FlowType.direct,
          height: constraints.maxHeight,
        ),
      ),
    );
  }
}
```

### Programmatic open

Open the Meili flow imperatively (e.g. on button tap):

```dart
import 'package:meili_flutter/meili_flutter.dart';

await Meili.openMeiliView(MeiliParams(
  ptid: 'your-ptid',
  env: 'prod',
  flow: FlowType.direct,
));
```

### Booking Manager flow

```dart
await Meili.openMeiliView(MeiliParams(
  ptid: 'your-ptid',
  env: 'prod',
  flow: FlowType.bookingManager,
  additionalParams: AdditionalParams(
    confirmationId: '1234ABCD',
    lastName: 'Doe',
  ),
));
```

### Prefill availability parameters

```dart
await Meili.openMeiliView(MeiliParams(
  ptid: 'your-ptid',
  env: 'prod',
  flow: FlowType.direct,
  availParams: AvailParams(
    pickupLocation: 'LHR',
    dropoffLocation: 'LHR',
    pickupDate: '2025-06-01',
    pickupTime: '10:00',
    dropoffDate: '2025-06-08',
    dropoffTime: '10:00',
    driverAge: 30,
    currencyCode: 'GBP',
    residency: 'GB',
  ),
));
```

### Listening for dismiss events

```dart
import 'package:meili_flutter/meili_flutter.dart';

class MyPage extends StatefulWidget { ... }

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    Meili.onEvent.listen((event) {
      if (event is MeiliFlowDismissed) {
        // User closed the Meili flow
        Navigator.of(context).pop();
      }
    });
  }
}
```

## Flows

| Flow | Description |
|------|-------------|
| `FlowType.direct` | Search and book a car rental |
| `FlowType.bookingManager` | View and manage an existing booking |

## Environments

| Value | Description |
|-------|-------------|
| `'prod'` | Production |
| `'pre_prod'` | Pre-production |
| `'uat'` | UAT |
| `'dev'` | Development |

## Contributing

Open issues or pull requests at [github.com/meili-travel-tech/flutter_meili](https://github.com/meili-travel-tech/flutter_meili).
