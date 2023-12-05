import Foundation

// NOTE: This solution is very lazy and slow (~ 15 min release build on ARM M1 Max)

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

let rawSeeds = input[0]
    .replacingOccurrences(of: "seeds: ", with: "")
    .split(separator: " ")
    .compactMap { Int($0) }

var seeds: [Range<Int>] = []
for i in stride(from: 0, to: rawSeeds.count, by: 2) {
    let start = rawSeeds[i]
    let end = start + rawSeeds[i + 1]
    seeds.append(start..<end)
}

var maps: [Map: [(dstRange: Range<Int>, srcRange: Range<Int>)]] = [:]

enum Map: String {
    case seedToSoil = "seed-to-soil"
    case soilToFertilizer = "soil-to-fertilizer"
    case fertilizerToWater = "fertilizer-to-water"
    case waterToLight = "water-to-light"
    case lightToTemperature = "light-to-temperature"
    case temperatureToHumidity = "temperature-to-humidity"
    case humidityToLocation = "humidity-to-location"
}

var currentMap: Map?
for line in input.suffix(from: 1) { // skip seeds
    if line.contains("map") {
        currentMap = Map(rawValue: line.replacingOccurrences(of: " map:", with: ""))!
        maps[currentMap!] = []
    } else {
        let values = line.split(separator: " ").compactMap { Int($0) }
        let destinationRange = values[0]..<(values[0] + values[2])
        let sourceRange = values[1]..<(values[1] + values[2])
        maps[currentMap!]!.append((destinationRange, sourceRange))
    }
}

var lowestLocation: Int?
let totalSeeds = seeds.count
for (index, seed) in seeds.enumerated() {
    print((Double(index) / Double(totalSeeds)).formatted(.percent), Date.now.formatted(date: .abbreviated, time: .complete))
    for value in seed {
        var next = value
        next = convert(next, using: .seedToSoil) ?? next
        next = convert(next, using: .soilToFertilizer) ?? next
        next = convert(next, using: .fertilizerToWater) ?? next
        next = convert(next, using: .waterToLight) ?? next
        next = convert(next, using: .lightToTemperature) ?? next
        next = convert(next, using: .temperatureToHumidity) ?? next
        next = convert(next, using: .humidityToLocation) ?? next
        if (lowestLocation ?? .max) > next {
            lowestLocation = next
        }
    }
}
print(lowestLocation!)

func convert(_ value: Int, using map: Map) -> Int? {
    if let map = maps[map]!.first(where: { _, srcRange in
        srcRange.contains(value)
    }), map.srcRange.contains(value) {
        let offset = value - map.srcRange.lowerBound
        let likelyNext = map.dstRange.lowerBound + offset
        if map.dstRange.contains(likelyNext) {
            return likelyNext
        }
    }

    return nil
}

