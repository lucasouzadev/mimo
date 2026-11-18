// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MimoDesignSystem",
    defaultLocalization: "pt",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "MimoDesignSystem", targets: ["MimoDesignSystem"]),
        .library(name: "MimoProfile", targets: ["MimoProfile"])
    ],
    targets: [
        .target(name: "MimoDesignSystem"),
        .target(name: "MimoProfile", dependencies: ["MimoDesignSystem"])
    ]
)
