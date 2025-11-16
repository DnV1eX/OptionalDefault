// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "OptionalDefault",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OptionalDefault",
            targets: ["OptionalDefault"]
        ),
        .executable(
            name: "OptionalDefaultClient",
            targets: ["OptionalDefaultClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0"..<"610.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "OptionalDefaultMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "OptionalDefault", dependencies: ["OptionalDefaultMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "OptionalDefaultClient", dependencies: ["OptionalDefault"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "OptionalDefaultTests",
            dependencies: [
                "OptionalDefaultMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
