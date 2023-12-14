import Foundation

func part1() throws {
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

            let result = collection[index]
            self.collection.formIndex(after: &index)
            if index == collection.endIndex {
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

    let target: Substring = "ZZZ"
    guard mappings.keys.contains(target) else {
        fatalError("Would go into infinite loop because ZZZ is not part of \(mappings)")
    }

    var iterator = LoopIterator(collection: directions) // custom endless iterator
    var nextKey: Substring = "AAA"
    var steps = 0
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

        steps += 1
        if nextKey == target { break }
    }
    print(steps)
}
