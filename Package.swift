// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "env-kit",
    products: [
        .library(name: "EnvKit", targets: ["EnvKit"]),
        .library(name: "EnvKitDynamic", type: .dynamic, targets: ["EnvKit"]),
    ],
    targets: [
        .target(name: "EnvKit", dependencies: []),
        .testTarget(name: "EnvKitTests", dependencies: ["EnvKit"]),
    ]
)
