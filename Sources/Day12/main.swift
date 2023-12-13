import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: offset)]
    }
}

struct KeyPair: Hashable {
    var p1: [Int]
    var p2: Substring

    init(_ p1: [Int], _ p2: Substring) {
        self.p1 = p1
        self.p2 = p2
    }
}

var storage: [KeyPair: Int] = [:]

var sum = 0
for line in input {
    let parts = line.split(separator: " ")
    let placement = Substring(Array(repeating: parts[0], count: 5).joined(separator: "?"))
    let groups = Array(repeating: parts[1], count: 5).joined(separator: ",").split(separator: ",").compactMap { Int($0) }

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
        let sum = hs(placement: placement, groups: groups)
        storage[.init(groups, placement)] = sum
        return sum
    case "?":
        let sum1 = solveRecursively(placement: placement.dropFirst(), groups: groups)
        let sum2 = hs(placement: placement, groups: groups)
        storage[.init(groups, placement)] = sum2
        return sum1 + sum2
    default:
        fatalError("unknown character \(placement)")
    }
}

func hs(placement: Substring, groups: [Int]) -> Int {
    if let sum = storage[.init(groups, placement)] {
        return sum
    }

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
