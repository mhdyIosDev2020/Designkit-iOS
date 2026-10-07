// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [
        .iOS(.v15)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
        // A browsable guide to every DesignKit component. Add it to your
        // app only if you want to show the catalog (e.g. in a debug menu).
        .library(
            name: "DesignKitCatalog",
            targets: ["DesignKitCatalog"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DesignKit",
            resources: [
                .process("Resources/ColorAsset.xcassets"),
                .process("Resources/IconAssets.xcassets"),
            ]),
        .target(
            name: "DesignKitCatalog",
            dependencies: ["DesignKit"]),
        .testTarget(
            name: "DesignKitTests",
            dependencies: ["DesignKit"]),
    ]
)
