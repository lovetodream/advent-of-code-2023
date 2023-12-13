import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> SubSequence {
        self[self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)]
    }
}

let patterns = input.split(separator: "\n\n")

var sum = 0
for pattern in patterns {
    let pattern = pattern.split(separator: "\n")
    let rows = pattern.count
    let columns = pattern.first!.count
    for row in 0..<rows {
        let shortest = min(row, rows - row)
        let part1 = Array(pattern[row..<(row + shortest)])
        let part2 = Array(pattern[(row - shortest)..<row].reversed())
        var matches = 0
        for i in 0..<part1.count {
            for j in 0..<part1[i].count where part1[i][j] == part2[i][j] {
                matches += 1
            }
        }
        if matches == (shortest * columns - 1) {
            sum += row * 100
        }
    }
    for column in 0..<columns {
        let shortest = min(column, columns - column)
        let part1 = pattern.map { row in
            row[column..<(column + shortest)]
        }
        let part2 = pattern.map { row in
            Substring(row[(column - shortest)..<column].reversed())
        }
        var matches = 0
        for i in 0..<part1.count {
            for j in 0..<part1[i].count where part1[i][j] == part2[i][j] {
                matches += 1
            }
        }
        if matches == (rows * shortest - 1) {
            sum += column
        }
    }
}
print(sum)

