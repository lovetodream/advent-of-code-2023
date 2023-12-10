import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)

struct Grid {
    var data: [UInt8]
    var offset: Int

    init(from string: String) {
        let lines = string.components(separatedBy: "\n")
        self.data = Array(lines.joined().data(using: .ascii)!)
        self.offset = lines.first?.count ?? 0
    }

    func findS() -> (Int, UInt8)? {
        let sPosition = self.data.firstIndex(of: UInt8(ascii: "S"))!

        let direction: UInt8
        if UInt8(ascii: "|") == self.data[sPosition - self.offset] ||
           UInt8(ascii: "7") == self.data[sPosition - self.offset] ||
           UInt8(ascii: "F") == self.data[sPosition - self.offset] {
            direction = 0
        } else if UInt8(ascii: "|") == self.data[sPosition + self.offset] ||
                  UInt8(ascii: "L") == self.data[sPosition + self.offset] ||
                  UInt8(ascii: "J") == self.data[sPosition + self.offset] {
            direction = 1
        } else if UInt8(ascii: "-") == self.data[sPosition - 1] ||
                  UInt8(ascii: "L") == self.data[sPosition - 1] ||
                  UInt8(ascii: "F") == self.data[sPosition - 1] {
            direction = 2
        } else if UInt8(ascii: "-") == self.data[sPosition + 1] ||
                  UInt8(ascii: "7") == self.data[sPosition + 1] ||
                  UInt8(ascii: "J") == self.data[sPosition + 1] {
            direction = 3
        } else {
            return nil
        }

        return (sPosition, direction)
    }

    func traverseLoop(from position: Int, in direction: UInt8) -> (Int, Set<Int>) {
        let go = self.offset
        let ap = [-go, go, -1, 1]
        var av = (position, direction)
        var set = Set<Int>()
        set.insert(position)

        while true {
            guard !av.0.addingReportingOverflow(ap[Int(av.1)]).overflow else { break }
            let np = av.0 + ap[Int(av.1)]
            guard let nextDir = data.indices.contains(np) ? nextDirection(dbit: av.1, pb: data[np]) : nil else { break }

            if set.insert(np).inserted {
                av = (np, nextDir)
            } else {
                break
            }
        }

        return (set.count / 2, set)
    }
}

func nextDirection(dbit: UInt8, pb: UInt8) -> UInt8? {
    switch (dbit, pb) {
    case (0, UInt8(ascii: "|")), (2, UInt8(ascii: "L")), (3, UInt8(ascii: "J")):
        return 0
    case (1, UInt8(ascii: "|")), (2, UInt8(ascii: "F")), (3, UInt8(ascii: "7")):
        return 1
    case (0, UInt8(ascii: "7")), (1, UInt8(ascii: "J")), (2, UInt8(ascii: "-")):
        return 2
    case (0, UInt8(ascii: "F")), (1, UInt8(ascii: "L")), (3, UInt8(ascii: "-")):
        return 3
    default:
        return nil
    }
}

func part1() {
    var grid = Grid(from: input)
    let (sPos, dir) = grid.findS()!
    let (steps, _) = grid.traverseLoop(from: sPos, in: dir)
    print("part 1:", steps)
}

func part2() {
    var grid = Grid(from: input)
    let (sPos, dir) = grid.findS()!
    let (_, set) = grid.traverseLoop(from: sPos, in: dir)
    var (total, inside) = (0, false)
    let valid = dir == 0
    for position in 0..<grid.data.count {
        if set.contains(position) {
            switch grid.data[position] {
            case UInt8(ascii: "|"), UInt8(ascii: "J"), UInt8(ascii: "L"):
                inside = !inside
            case UInt8(ascii: "S"):
                if valid {
                    inside = !inside
                }
            default:
                break
            }
        } else {
            total += inside ? 1 : 0
        }
        if position % grid.offset == grid.offset - 1 {
            inside = false
        }
    }
    print("part 2:", total)
}

part1()
part2()
