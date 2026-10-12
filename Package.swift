// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-xxhash",
    // UInt128 needs these.
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(name: "XXHash", targets: ["XXHash"]),
    ],
    targets: [
        // The official xxHash C sources, unmodified (see Sources/CXXHash/VERSION).
        .target(name: "CXXHash"),
        .target(name: "XXHash", dependencies: ["CXXHash"]),
        .testTarget(name: "XXHashTests", dependencies: ["XXHash"]),
    ]
)
