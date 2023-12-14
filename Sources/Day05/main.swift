import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

struct Rule {
    var destination: Int
    var source: Int
    var range: Int
}

struct OptimizableRange {
    var from: Int
    var to: Int
}

let rawSeeds = input[0]
    .replacingOccurrences(of: "seeds: ", with: "")
    .split(separator: " ")
    .compactMap { Int($0) }

var seeds: [OptimizableRange] = []
for i in stride(from: 0, to: rawSeeds.count, by: 2) {
    let start = rawSeeds[i]
    let end = start + rawSeeds[i + 1]
    seeds.append(OptimizableRange(from: start, to: end))
}

var maps: [[Rule]] = []

for line in input.suffix(from: 1) { // skip seeds
    if line.contains("map") {
        // sort recent to allow range based iteration later
        if !maps.isEmpty {
            maps[maps.count - 1].sort(by: { $0.source < $1.source })
        }
        maps.append([])
    } else {
        let values = line.split(separator: " ").compactMap { Int($0) }
        maps[maps.count - 1].append(.init(
            destination: values[0],
            source: values[1],
            range: values[2]
        ))
    }
}

let runtime = ContinuousClock().measure {
    var currentRanges = seeds

    // go through every map starting with seeds to soils...
    for map in maps {
        var newRanges = [OptimizableRange]()

        for var range in currentRanges {
            for rule in map {
                let offset = rule.destination - rule.source

                // check fast path
                let ruleApplies = range.from <= range.to
                    && range.from <= (rule.source + rule.range)
                    && range.to >= rule.source

                // check if we have to adjust the ranges for the next mapping
                if ruleApplies {
                    if range.from < rule.source {
                        newRanges.append(.init(
                            from: range.from, to: rule.source - 1
                        ))
                        range.from = rule.source
                        if range.to < (rule.source + rule.range) {
                            newRanges.append(.init(
                                from: range.from + offset, to: range.to + offset
                            ))
                            range.from = range.to + 1
                        } else {
                            newRanges.append(.init(
                                from: range.from + offset,
                                to: rule.source + rule.range - 1 + offset
                            ))
                            range.from = rule.source + rule.range
                        }
                    } else if range.to < (rule.source + rule.range) {
                        newRanges.append(.init(
                            from: range.from + offset, to: range.to + offset
                        ))
                        range.from = range.to + 1
                    } else {
                        newRanges.append(.init(
                            from: range.from + offset,
                            to: rule.source + rule.range - 1 + offset
                        ))
                        range.from = rule.source + rule.range
                    }
                }
            }
            if range.from <= range.to {
                newRanges.append(range)
            }
        }
        currentRanges = newRanges
    }

    print(currentRanges.map(\.from).min()!)
}
print(runtime)
