// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterMainUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TwitterMainUI",
            targets: ["TwitterMainUI"]),
    ],
    dependencies: [
        .package(path: "TwitterHomeUI"),
        .package(path: "TwitterTrendsUI"),
        .package(path: "TwitterNotificationsUI"),
        .package(path: "TwitterMessagesUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TwitterMainUI",
            dependencies: ["TwitterHomeUI", "TwitterTrendsUI", "TwitterNotificationsUI", "TwitterMessagesUI"]
        )
    ]
)
