// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "plan",
  platforms: [
    .macOS(.v15),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.5.1"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.14.0"),
    .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),
    .package(url: "https://github.com/bigMOTOR/swift-lens", from: "1.1.0"),
    .package(url: "https://github.com/hectr/swift-when", revision: "0306cc7c39ba72e54eb35512beb9140421ec81ab"),
  ],
  targets: [
    .executableTarget(
      name: "plan",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "Stencil", package: "Stencil"),
        .product(name: "swift-lens", package: "swift-lens"),
        .product(name: "when", package: "swift-when"),
      ],
      path: "Sources"
    ),
    .testTarget(
      name: "test",
      dependencies: ["plan"],
      path: "Tests"
    ),
  ],
  swiftLanguageModes: [.v5]
)
