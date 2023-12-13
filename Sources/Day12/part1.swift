import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")

    var sum = 0
    for line in input {
        let parts = line.split(separator: " ")
        let placement = parts[0]
        let groups = parts[1].split(separator: ",").compactMap { Int($0) }

        sum += solveRecursively(placement: placement, groups: groups)
    }
    print(sum)

    func solveRecursively(placement: Substring, groups: [Int]) -> Int {
        if placement.isEmpty {
            if groups.isEmpty {
                return 1
            }
            return 0
        }

        switch placement.first {
        case ".":
            return solveRecursively(placement: placement.dropFirst(), groups: groups)
        case "#":
            return hs(placement: placement, groups: groups)
        case "?":
            return solveRecursively(placement: placement.dropFirst(), groups: groups)
            + hs(placement: placement, groups: groups)
        default:
            fatalError("unknown character \(placement)")
        }
    }

    func hs(placement: Substring, groups: [Int]) -> Int {
        if groups.isEmpty { return 0 }

        let x = groups[0]
        if placement.count < x { return 0 }

        for i in 0..<x where placement[i] == "." {
            return 0
        }

        if placement.count == x {
            if groups.count == 1 { return 1 }
            return 0
        }

        if placement[x] == "#" {
            return 0
        }

        return solveRecursively(placement: placement.dropFirst(x + 1), groups: Array(groups.dropFirst()))
    }
}
