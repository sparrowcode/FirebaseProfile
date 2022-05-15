// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FRMNAME",
    platforms: [
        .iOS(.v13), 
        .tvOS(.v13), 
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FRMNAME",
            targets: ["FRMNAME"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FRMNAME",
            swiftSettings: [
                .define("FRMNAME_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
