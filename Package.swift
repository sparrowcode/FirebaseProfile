// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FirebaseProfile",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FirebaseProfile",
            targets: ["FirebaseProfile"]
        )
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "8.13.0")
        )
    ],
    targets: [
        .target(
            name: "FirebaseProfile",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase")
            ]
            swiftSettings: [
                .define("FIREBASEPROFILE_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
