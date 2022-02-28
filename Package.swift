// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SPProfiling",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SPProfiling",
            targets: ["SPProfiling"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ivanvorobei/SPAlert", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/ivanvorobei/NativeUIKit", .upToNextMajor(from: "1.4.5")),
        .package(url: "https://github.com/ivanvorobei/SPFirebase", .upToNextMajor(from: "1.0.8")),
        .package(url: "https://github.com/sparrowcode/SPSafeSymbols", .upToNextMajor(from: "1.0.5")),
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "10.7.1"))
    ],
    targets: [
        .target(
            name: "SPProfiling",
            dependencies: [
                .product(name: "SPAlert", package: "SPAlert"),
                .product(name: "NativeUIKit", package: "NativeUIKit"),
                .product(name: "SPFirebaseAuth", package: "SPFirebase"),
                .product(name: "SPFirebaseFirestore", package: "SPFirebase"),
                .product(name: "SPFirebaseMessaging", package: "SPFirebase"),
                .product(name: "SPFirebaseStorage", package: "SPFirebase"),
                .product(name: "SPSafeSymbols", package: "SPSafeSymbols"),
                .product(name: "Nuke", package: "Nuke")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
