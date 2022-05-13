// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FirebaseProfile",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FirebaseProfile", targets: ["FirebaseProfile"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FirebaseProfile",
            swiftSettings: [
                .define("FIREBASEPROFILE_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
