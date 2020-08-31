// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONValue",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "JSONValue",
            targets: ["JSONValue"]),
    ],
    targets: [
        .target(
            name: "JSONValue",
            dependencies: []),
        .testTarget(
            name: "JSONValueTests",
            dependencies: ["JSONValue"]),
    ]
)
