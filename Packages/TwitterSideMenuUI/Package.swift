// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterSideMenuUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TwitterSideMenuUI",
            targets: ["TwitterSideMenuUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
        .package(path: "SwiftUtilities")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TwitterSideMenuUI",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                "SwiftUtilities"
            ]
        ),
    ]
)
