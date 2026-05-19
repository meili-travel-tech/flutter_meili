# Meili Flutter Plugin

[![pub package](https://img.shields.io/pub/v/meili_flutter.svg)](https://pub.dev/packages/meili_flutter)

The Meili Flutter Plugin allows you to integrate the Meili car rental experience into your Flutter applications on both iOS and Android.

## Overview

`meili_flutter` is a federated Flutter plugin that wraps the native Meili UX SDKs:

- **Android** native SDK: hosted as a Maven artifact on GitHub Packages at `meili-travel-tech/ux-native-android-sdk` (requires auth).
- **iOS** native SDK: distributed as a CocoaPod (`MeiliSDK`) via a private spec repo at `meili-travel-tech/meili-ios-pods` (requires SSH/HTTPS access).

---

## Prerequisites

| Requirement | Why |
|---|---|
| Flutter SDK `>=3.4.0` | Minimum required by the plugin. |
| Android Studio / Xcode CLI tools | Needed for native builds. |
| CocoaPods (`gem install cocoapods`) | iOS dependency manager. |
| GitHub Personal Access Token with `read:packages` scope | Downloads the Android AAR from GitHub Packages. |
| Membership in the `meili-travel-tech` GitHub org | Both the iOS spec repo and Android Maven artifacts are under this org. Contact Meili to get access. |

---

## 1. Dart / pubspec setup

```yaml
dependencies:
  meili_flutter: 0.3.1-beta.1
```

```bash
flutter pub get
```

This resolves the federated sub-packages automatically — you do not need to add `meili_flutter_android` or `meili_flutter_ios` manually.

---

## 2. Android setup

### 2.1 GitHub credentials

The Android SDK is hosted on a private GitHub Packages repo. Set these environment variables before building:

```bash
export MEILI_GITHUB_USERNAME="your-github-username"
export MEILI_GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
```

**Where to put them:**
- CLI builds (`flutter run` in Terminal): append to `~/.zshrc`
- IDE / GUI app builds (Android Studio, VS Code launched from Finder): append to `~/.zshenv` — GUI apps on macOS don't always source `~/.zshrc`

After editing, reload with `source ~/.zshenv` or open a new terminal.

**Verifying:**
```bash
echo "${MEILI_GITHUB_USERNAME:-NOT_SET}"
[ -n "$MEILI_GITHUB_TOKEN" ] && echo "TOKEN_SET" || echo "TOKEN_NOT_SET"
```

**Failure mode:** if credentials are missing you will see:
```
Could not resolve meili.travel:ux-native-android-sdk:...
  > Received status code 401 from server: Unauthorized
```

### 2.2 `android/build.gradle.kts` — declare the Maven repo

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/meili-travel-tech/ux-native-android-sdk")
            credentials {
                username = System.getenv("MEILI_GITHUB_USERNAME") ?: ""
                password = System.getenv("MEILI_GITHUB_TOKEN") ?: ""
            }
        }
    }
}
```

### 2.3 `android/app/build.gradle.kts` — NDK + minSdk

```kotlin
android {
    ndkVersion = "27.0.12077973"
    defaultConfig {
        minSdk = 27
    }
}
```

- `ndkVersion` must be pinned exactly — using `flutter.ndkVersion` may cause a linker error.
- `minSdk = 27` is required by the Meili Android SDK.

### 2.4 `android/settings.gradle.kts` — Kotlin Compose plugin

```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.1.0" apply false  // add this
}
```

### 2.5 `MainActivity.kt`

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

> If you leave `FlutterActivity` here you will get an `IllegalStateException` at runtime when opening the Meili view.

---

## 3. iOS setup

### 3.1 `ios/Podfile`

```ruby
platform :ios, '16.0'

source 'https://cdn.cocoapods.org/'
source 'git@github.com:meili-travel-tech/meili-ios-pods.git'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

# ... rest of the standard Flutter Podfile unchanged
```

> If you use a multi-account SSH setup, replace `git@github.com:` with your Host alias e.g. `git@github.com-meili:`.

### 3.2 iOS deployment target

Set `IPHONEOS_DEPLOYMENT_TARGET = 16.0` in three places in `ios/Runner.xcodeproj/project.pbxproj` (Debug, Release, Profile), or via Xcode under **Runner target → General → Minimum Deployments → iOS**.

### 3.3 `ios/Flutter/AppFrameworkInfo.plist`

```xml
<key>MinimumOSVersion</key>
<string>16.0</string>
```

### 3.4 Install pods

```bash
cd ios && pod install --repo-update && cd ..
```

`--repo-update` is needed the first time to clone the private spec repo. Plain `pod install` is sufficient on subsequent runs.

---

## 4. Usage

### Embedded widget

```dart
import 'package:meili_flutter/meili_flutter.dart';

MeiliView(
  ptid: 'your-ptid',
  env: 'prod',               // 'dev', 'uat', 'pre_prod', 'prod'
  currentFlow: FlowType.direct,
  availParams: AvailParams(
    pickupLocation: 'DXB',
    dropoffLocation: 'DXB',
    pickupDate: '2025-06-01',
    pickupTime: '10:00',
    dropoffDate: '2025-06-05',
    dropoffTime: '10:00',
    driverAge: 30,
    currencyCode: 'USD',
    residency: 'US',
  ),
)
```

### Full-screen modal

```dart
import 'package:meili_flutter/meili_flutter.dart';

await Meili.openMeiliView(MeiliParams(
  ptid: 'your-ptid',
  env: 'prod',
  flow: FlowType.direct,
));
```

### Booking Manager

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

---

## 5. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `401 Unauthorized` resolving Maven dep | `MEILI_GITHUB_TOKEN` missing or lacks `read:packages` scope | Re-create PAT with `read:packages`, export, restart shell. |
| `Could not find ... .aar` during Gradle | Maven repo URL or token missing | Check `build.gradle.kts` repo block and env vars. |
| `Unable to find a specification for MeiliSDK` | Missing `source` line in Podfile | Add the private spec repo URL. |
| `pod install` hangs on first run | First-time SSH clone of spec repo | Confirm SSH key: `ssh -T git@github.com`. |
| `IllegalStateException ... requires FragmentActivity` | `MainActivity` still extends `FlutterActivity` | Change to `FlutterFragmentActivity`. |
| NDK strip / linker errors | NDK version mismatch | Pin `ndkVersion = "27.0.12077973"`. |
| Env vars set in terminal but not in Android Studio | macOS GUI apps don't load `~/.zshrc` | Move env vars to `~/.zshenv`, relaunch Android Studio. |

---

## Platform Support

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |

## Contributing

Open issues or pull requests at [github.com/meili-travel-tech/flutter_meili](https://github.com/meili-travel-tech/flutter_meili).
