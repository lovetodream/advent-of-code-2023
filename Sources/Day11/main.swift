import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[self.index(startIndex, offsetBy: offset)]
    }
}

struct Coordinate {
    var x: Int
    var y: Int

    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

func manhattan(_ lhs: Coordinate, _ rhs: Coordinate) -> Int {
    abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
}

struct Grid {
    var rows: [Substring]
    var galaxies: [Coordinate]
    var emptyRows: [Int]
    var emptyColumns: [Int]

    static func parse(from input: String) -> Grid {
        let rows = input.split(separator: "\n")
        let emptyRows = rows.enumerated()
            .filter { $0.1.allSatisfy { $0 == "." } }
            .map { $0.0 }

        var emptyColumns = [Int]()
        for (index, _) in rows[0].enumerated() { // for each column index
            if rows.map({ $0[index] }).allSatisfy({ $0 == "." }) {
                emptyColumns.append(index)
            }
        }

        var galaxies: [Coordinate] = []
        for (y, row) in rows.enumerated() {
            for (x, val) in row.enumerated() {
                if val == "#" {
                    galaxies.append(Coordinate(x: x, y: y))
                }
            }
        }

        return Grid(
            rows: rows,
            galaxies: galaxies,
            emptyRows: emptyRows,
            emptyColumns: emptyColumns
        )
    }
}

func pairs<T>(_ list: [T]) -> [(T, T)] {
    var array: [(T, T)] = []
    for (i, a) in list.enumerated() {
        for (j, b) in list.enumerated() {
            if i < j {
                array.append((a, b))
            }
        }
    }
    return array
}

func distanceBetween(_ a: Coordinate, _ b: Coordinate, on grid: Grid, expansion: Int) -> Int {
    let xRange = a.x <= b.x ? a.x...b.x : b.x...a.x
    let yRange = a.y <= b.y ? a.y...b.y : b.y...a.y

    let growth =
        grid.emptyColumns.filter { xRange.contains($0) }.count
        + grid.emptyRows.filter { yRange.contains($0) }.count

    return manhattan(a, b) - growth + (expansion * growth)
}

func answer(_ input: String, expansion: Int) -> Int {
    let grid = Grid.parse(from: input)
    return pairs(grid.galaxies)
        .map { distanceBetween($0.0, $0.1, on: grid, expansion: expansion) }
        .reduce(0, +)
}

print("part 1:", answer(input, expansion: 2))
print("part 2:", answer(input, expansion: 1_000_000))
