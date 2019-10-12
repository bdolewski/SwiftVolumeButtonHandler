// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftVolumeButtonHandler",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "SwiftVolumeButtonHandler",
            targets: ["SwiftVolumeButtonHandler"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftVolumeButtonHandler",
            dependencies: [])
    ]
)
