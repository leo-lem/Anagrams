// swift-tools-version: 6.0

import PackageDescription

let deps = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "Model", plugins: [lint]),
  .target(name: "Words", dependencies: ["Model", deps], resources: [
    .process("de.json"), .process("en.json"), .process("fr.json"), .process("es.json")
  ], plugins: [lint]),
  .target(name: "CKClient", dependencies: ["Model", deps], plugins: [lint])
]

let package = Package(
  name: "Library",
  defaultLocalization: "en",
  platforms: [.iOS(.v17), .macOS(.v15)],
  products: libs.map { .library(name: $0.name, targets: [$0.name]) },
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
  ],
  targets: libs + [
    .testTarget(name: "LibraryTest", dependencies: libs.map { .byName(name: $0.name) }, path: "Test", plugins: [lint])
  ]
)
