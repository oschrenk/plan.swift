// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "plan",
  platforms: [
    .macOS(.v14),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.5.0"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
  ],
  targets: [
    .executableTarget(
      name: "plan",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      path: "Sources"
    ),
    .testTarget(
      name: "test",
      dependencies: ["plan"],
      path: "Tests"
    ),
  ]
)
