// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "Day1", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day2", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day3", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day4", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day5", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day6", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day7", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day8", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day9", resources: [.copy("input.txt")]),
    ]
)
