// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "meili_flutter_ios",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(name: "meili-flutter-ios", targets: ["meili_flutter_ios"])
    ],
    dependencies: [
        // Binary distribution of MeiliSDK. The XCFramework bakes in the
        // third-party SDKs (Stripe, Evervault, HorizonCalendar, Shimmer,
        // PhoneNumberKit, SwiftUIPager), so nothing else is declared here.
        //
        // `exact:` (not `from:`) because only pre-release tags exist today
        // (1.6.3-alpha.N); SwiftPM excludes pre-releases from `from:` ranges.
        // Switch to `from: "1.6.0"` once a stable 1.6.x ships.
        .package(url: "https://github.com/meili-travel-tech/ux-native-ios", exact: "1.6.3-alpha.10")
    ],
    targets: [
        .target(
            name: "meili_flutter_ios",
            dependencies: [
                .product(name: "MeiliSDK", package: "ux-native-ios")
            ]
            // The `Flutter` module is injected by Flutter's build tooling;
            // it is intentionally NOT declared as a SwiftPM dependency.
        )
    ]
)
