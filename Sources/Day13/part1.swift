import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    )
    
    let patterns = input.split(separator: "\n\n")
    
    var sum = 0
    for pattern in patterns {
        let pattern = pattern.split(separator: "\n")
        let rows = pattern.count
        let columns = pattern.first!.count
        for row in 0..<rows {
            let shortest = min(row, rows - row)
            if pattern[row..<(row + shortest)].elementsEqual(pattern[(row - shortest)..<row].reversed()) {
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
            if part1.elementsEqual(part2) {
                sum += column
            }
        }
    }
    print(sum)
}
