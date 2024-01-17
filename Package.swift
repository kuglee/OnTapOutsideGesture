// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OnTapOutsideGesture",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
    products: [
        .library(
            name: "OnTapOutsideGesture",
            targets: ["OnTapOutsideGesture"]),
    ],
    targets: [
        .target(
            name: "OnTapOutsideGesture"),
        .testTarget(
            name: "OnTapOutsideGestureTests",
            dependencies: ["OnTapOutsideGesture"]),
    ]
)
