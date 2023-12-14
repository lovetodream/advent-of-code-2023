import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)

struct Point: Hashable {
    let x: Int
    let y: Int

    func adding(_ other: Point) -> Point {
        Point(x: self.x + other.x, y: self.y + other.y)
    }
}

var grid: [Point: Character] = [:]

let rows = input.split(separator: "\n")
let height = rows.count
let width = rows[0].count

for (y, row) in rows.enumerated() {
    for (x, char) in row.enumerated() where char != "." {
        let point = Point(x: x, y: y)
        grid[point] = char
    }
}

var seen: [String:Int] = [:]
var i = 0
var foundCycle = false

while i < 1000000000 {
    grid.moveNorth(width: width, height: height)
    grid.moveWest(width: width, height: height)
    grid.moveSouth(width: width, height: height)
    grid.moveEast(width: width, height: height)

    let cacheKey = grid.cacheKey()
    guard !foundCycle else {
        i += 1
        continue
    }
    if let first = seen[cacheKey] {
        foundCycle = true
        let loopLength = i - first
        let finished = (1000000000 - i - 1) % loopLength
        i = 1000000000 - finished
    } else {
        seen[cacheKey] = i
        i += 1
    }
}

let load = grid.calculateLoad(height: height)
print(load)

extension Dictionary where Key == Point, Value == Character {
    func cacheKey() -> String {
        let sorted = self.sorted { lhs, rhs in
            if lhs.key.y < rhs.key.y {
                return true
            }
            if lhs.key.y > rhs.key.y {
                return false
            }
            return lhs.key.x < rhs.key.x
        }
        return sorted.reduce("") { res, curr in
            res + "(\(curr.key.x),\(curr.key.y)):\(curr.value)"
        }
    }

    mutating func moveNorth(width: Int, height: Int) {
        var hasMoved = false
        var step = 0
        var toMove = self.filter { $0.value == "O" }.sorted { lhs, rhs in
            if lhs.key.y < rhs.key.y {
                return true
            }
            if lhs.key.y > rhs.key.y {
                return false
            }
            return lhs.key.x < rhs.key.x
        }
        repeat {
            hasMoved = false

            for (idx, (point, char)) in toMove.enumerated() {
                let north = point.adding(Point(x: 0, y: -1))
                guard north.y >= 0, self[north] == nil else {
                    continue
                }
                self[point] = nil
                self[north] = char
                hasMoved = true
                toMove[idx] = (north, char)
            }
            step += 1

        } while hasMoved
    }

    mutating func moveSouth(width: Int, height: Int) {
        var hasMoved = false

        var step = 0
        var toMove = self.filter { $0.value == "O" }.sorted { lhs, rhs in
            if lhs.key.y > rhs.key.y {
                return true
            }
            if lhs.key.y < rhs.key.y {
                return false
            }
            return lhs.key.x < rhs.key.x
        }
        repeat {
            hasMoved = false

            for (idx, (point, char)) in toMove.enumerated() {
                let south = point.adding(Point(x: 0, y: 1))
                guard south.y < height, self[south] == nil else {
                    continue
                }
                self[point] = nil
                self[south] = char
                hasMoved = true
                toMove[idx] = (south, char)
            }
            step += 1

        } while hasMoved
    }

    mutating func moveEast(width: Int, height: Int) {
        var hasMoved = false
        var step = 0
        var toMove = self.filter { $0.value == "O" }.sorted { lhs, rhs in
            if lhs.key.x > rhs.key.x {
                return true
            }
            if lhs.key.x < rhs.key.x {
                return false
            }
            return lhs.key.y < rhs.key.y
        }
        repeat {
            hasMoved = false

            for (idx, (point, char)) in toMove.enumerated() {
                let east = point.adding(Point(x: 1, y: 0))
                guard east.x < width, self[east] == nil else {
                    continue
                }
                self[point] = nil
                self[east] = char
                hasMoved = true
                toMove[idx] = (east, char)
            }
            step += 1

        } while hasMoved
    }

    mutating func moveWest(width: Int, height: Int) {
        var hasMoved = false

        var toMove = self.filter { $0.value == "O" }.sorted { lhs, rhs in
            if lhs.key.x < rhs.key.x {
                return true
            }
            if lhs.key.x > rhs.key.x {
                return false
            }
            return lhs.key.y < rhs.key.y
        }
        var step = 0
        repeat {
            hasMoved = false

            for (idx, (point, char)) in toMove.enumerated() {
                let west = point.adding(Point(x: -1, y: 0))
                guard west.x >= 0, self[west] == nil else {
                    continue
                }
                self[point] = nil
                self[west] = char
                hasMoved = true
                toMove[idx] = (west, char)
            }
            step += 1

        } while hasMoved
    }

    func calculateLoad(height: Int) -> Int {
        self
            .filter { $0.value == "O" }
            .reduce(0) { res, curr in
                res + (height - curr.key.y)
            }
    }
}
