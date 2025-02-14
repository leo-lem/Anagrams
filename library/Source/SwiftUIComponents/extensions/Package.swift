// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Extensions",
  platforms: [.iOS(.v16), .macOS(.v12)]
)

let libs: [Target] = [
  .target(name: "Concurrency"),
  .target(name: "Errors"),
  .target(name: "Previews"),
  .target(name: "Queries"),
  .target(name: "Extensions", dependencies: ["Previews"]),
]

// MARK: - (DEPENDENCIES)

package.dependencies = []

// MARK: - (TARGETS)

package.targets = libs
  .flatMap {[
    $0,
    .testTarget(
      name: "\($0.name)Tests",
      dependencies: [.target(name: $0.name)],
      path: "Test/\($0.name)"
    )
  ]}

// MARK: - (PRODUCTS)

package.products = libs.map { .library(name: $0.name, targets: [$0.name]) }
