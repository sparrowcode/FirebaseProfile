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
        .package(
            name: "NativeUIKit",
            url: "https://github.com/ivanvorobei/NativeUIKit", .upToNextMajor(from: "1.3.1")
        ),
        .package(
            name: "SPFirebase",
            url: "https://github.com/ivanvorobei/SPFirebase", .upToNextMajor(from: "1.0.4")
        ),
        .package(
            name: "SPSafeSymbols",
            url: "https://github.com/sparrowcode/SPSafeSymbols", .upToNextMajor(from: "1.0.4")
        )
    ],
    targets: [
        .target(
            name: "SPProfiling",
            dependencies: [
                .product(name: "NativeUIKit", package: "NativeUIKit"),
                .product(name: "SPFirebaseAuth", package: "SPFirebase"),
                .product(name: "SPFirebaseFirestore", package: "SPFirebase"),
                .product(name: "SPFirebaseMessaging", package: "SPFirebase"),
                .product(name: "SPFirebaseStorage", package: "SPFirebase"),
                .product(name: "SPSafeSymbols", package: "SPSafeSymbols"),
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
