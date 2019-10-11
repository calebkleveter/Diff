// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Diff",
    products: [
        .library(name: "Diff", targets: ["Diff"]),
    ],
    dependencies: [
        .package(url: "https://github.com/calebkleveter/KeyPathReflector.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "Diff", dependencies: ["KeyPathReflector"]),
        .testTarget(name: "DiffTests", dependencies: ["Diff"]),
    ]
)
