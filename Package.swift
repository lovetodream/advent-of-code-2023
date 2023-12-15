// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "Day01", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day02", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day03", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day04", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day05", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day06", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day07", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day08", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day09", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day10", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day11", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day12", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day13", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day14", resources: [.copy("input.txt")]),
        .executableTarget(name: "Day15", resources: [.copy("input.txt")]),
    ]
)
