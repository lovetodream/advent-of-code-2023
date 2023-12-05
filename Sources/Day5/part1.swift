import Foundation

func part1() throws {

    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")

    let seeds = input[0]
        .replacingOccurrences(of: "seeds: ", with: "")
        .split(separator: " ")
        .compactMap { Int($0) }

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

    var locations = [Int]()
    for seed in seeds {
        var next = seed
        next = convert(next, using: .seedToSoil) ?? next
        next = convert(next, using: .soilToFertilizer) ?? next
        next = convert(next, using: .fertilizerToWater) ?? next
        next = convert(next, using: .waterToLight) ?? next
        next = convert(next, using: .lightToTemperature) ?? next
        next = convert(next, using: .temperatureToHumidity) ?? next
        next = convert(next, using: .humidityToLocation) ?? next
        locations.append(next)
    }
    print(locations.min()!)

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

}
