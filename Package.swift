// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaskFramework",
    products: [
        .library(
            name: "TaskFramework",
            targets: ["TaskFramework"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TaskFramework",
            dependencies: []),
        .testTarget(
            name: "TaskFrameworkTests",
            dependencies: ["TaskFramework"]),
    ]
)
