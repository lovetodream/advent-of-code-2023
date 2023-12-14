import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    )

    let columnCount = input.prefix(upTo: input.firstIndex(of: "\n")!).count
    var rows = input.split(separator: "\n").map { Array($0) }

    var sum = 0
    for index in 0..<columnCount {
        var column = rows.map { $0[index] }
        for charIndex in 0..<column.count {
            var previousIndex = charIndex - 1
            while previousIndex >= 0 {
                if column[previousIndex] == "." && column[previousIndex + 1] == "O" {
                    column[previousIndex] = column[previousIndex + 1]
                    column[previousIndex + 1] = "."
                }
                previousIndex -= 1
            }
        }
        var charIndex = 0
        for (index, char) in column.enumerated() {
            rows[index][charIndex] = char
            charIndex += 1
            if char == "O" {
                sum += rows.count - index
            }
        }
    }
    let printableRows = rows.map { $0.reduce(into: "", { $0.append($1) }) }
    print(printableRows.joined(separator: "\n"))
    print(sum)
}
