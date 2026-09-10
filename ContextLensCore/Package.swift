// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ContextLensCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "ContextLensCore", targets: ["ContextLensCore"])],
    targets: [
        .target(name: "ContextLensCore"),
        .testTarget(name: "ContextLensCoreTests", dependencies: ["ContextLensCore"])
    ]
)
