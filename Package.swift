// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FinancialEntities",
    platforms: [
            .iOS(.v13),
            .macOS(.v12)
        ],
    products: [
        .library(
            name: "FinancialEntities",
            targets: ["FinancialEntities"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.55.0"),
    ],
    targets: [
        .target(
            name: "FinancialEntities",
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ],
        plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]),
        .testTarget(
            name: "FinancialEntitiesTests",
            dependencies: ["FinancialEntities"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ]
)
