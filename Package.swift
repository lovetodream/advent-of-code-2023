// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "Day1", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day2", resources: [.copy("input.txt")]),
    ]
)
