// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Diff",
    products: [
        .library(name: "Diff", targets: ["Diff"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Diff", dependencies: []),
        .testTarget(name: "DiffTests", dependencies: ["Diff"]),
    ]
)
