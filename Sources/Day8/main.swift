import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

enum Direction: Character {
    case left = "L"
    case right = "R"
}

struct LoopIterator<Base: Collection>: IteratorProtocol {
    private let collection: Base
    private var index: Base.Index

    init(collection: Base) {
        self.collection = collection
        self.index = collection.startIndex
    }

    mutating func next() -> Base.Iterator.Element? {
        guard !self.collection.isEmpty else {
            return nil
        }

        let result = self.collection[self.index]
        self.collection.formIndex(after: &self.index)
        if self.index == self.collection.endIndex {
            self.index = self.collection.startIndex
        }
        return result
    }
}

let directions = input[0].compactMap(Direction.init)

var mappings: [Substring: (left: Substring, right: Substring)] = [:]

for line in input.dropFirst() { // skip directions
    let parts = line.split(separator: " = ")
    let key = parts[0]
    let directionParts = parts[1].dropFirst().dropLast().split(separator: ", ") // + removes '(' & ')'
    mappings[key] = (directionParts[0], directionParts[1])
}

var iterator = LoopIterator(collection: directions) // custom endless iterator
var nextKeys: [Substring] = mappings.keys.filter { $0.hasSuffix("A") }
var steps: [Int] = []
for var nextKey in nextKeys {
    let index = steps.endIndex
    steps.append(0)
    while let direction = iterator.next() {
        guard let next = mappings[nextKey] else {
            fatalError("No value for key \(nextKey)")
        }
        switch direction {
        case .left:
            nextKey = next.left
        case .right:
            nextKey = next.right
        }

        steps[index] += 1
        if nextKey.hasSuffix("Z") { break }
    }
}
print(lcm(steps))

func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}


func lcm(_ x: Int, _ y: Int) -> Int { x / gcd(x, y) * y }

func lcm(_ values: [Int]) -> Int {
    var ans = values[0]

    for i in 1..<values.count {
        ans = (values[i] * ans) / gcd(values[i], ans)
    }

    return ans
}
