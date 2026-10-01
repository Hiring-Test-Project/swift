// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SumAmounts",
    products: [
        .library(name: "SumAmounts", targets: ["SumAmounts"]),
    ],
    targets: [
        .target(name: "SumAmounts"),
        .testTarget(name: "SumAmountsTests", dependencies: ["SumAmounts"]),
    ]
)
