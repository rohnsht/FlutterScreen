// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_screen",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-screen", targets: ["flutter_screen"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_screen",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                // If this plugin requires a privacy manifest (e.g. it uses
                // required reason APIs), update PrivacyInfo.xcprivacy and
                // uncomment the following line:
                // .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
