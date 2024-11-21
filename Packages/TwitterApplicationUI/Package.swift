// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterApplicationUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TwitterApplicationUI",
            targets: ["TwitterApplicationUI"]),
    ],
    dependencies: [
        .package(path: "TwitterMainUI"),
        .package(path: "TwitterSideMenuUI"),
        .package(path: "SwiftUtilities"),
        .package(path: "UIKitUtilities"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TwitterApplicationUI",
            dependencies: ["TwitterMainUI", "TwitterSideMenuUI", "SwiftUtilities", "UIKitUtilities"]
        ),
    ]
)
