import Foundation
import RegexBuilder

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

func checkIfStarHasTwoNumbers(
    rowIndex: [String.SubSequence].Index,
    columnIndex: String.SubSequence.Index
) -> (Int, Int)? {
    let row = String(input[rowIndex])

    var foundNumbers = [Int]()

    // check previous chars
    if columnIndex != row.startIndex {
        let previousColumnIndex = row.index(before: columnIndex)
        if row[previousColumnIndex].isNumber, let number = extractNumbers(from: row[...previousColumnIndex]).last {
            foundNumbers.append(number)
        }
    }

    // check following chars
    if columnIndex != row.endIndex {
        let nextColumnIndex = row.index(after: columnIndex)
        if row[nextColumnIndex].isNumber, let number = extractNumbers(from: row[nextColumnIndex...]).first {
            foundNumbers.append(number)
        }
    }

    // check previous row
    if rowIndex != input.startIndex {
        let previousRow = String(input[rowIndex - 1])
        let firstColumnIndex: Substring.Index
        if columnIndex == previousRow.startIndex {
            firstColumnIndex = columnIndex
        } else {
            firstColumnIndex = previousRow.index(before: columnIndex)
        }
        var lastColumnIndex = previousRow.index(after: columnIndex)
        if lastColumnIndex >= previousRow.endIndex {
            lastColumnIndex = previousRow.index(before: previousRow.endIndex)
        }
        let range = firstColumnIndex...lastColumnIndex
        let numbers = extractNumbers(in: range, of: previousRow)
        foundNumbers.append(contentsOf: numbers)
    }

    // check next row
    if rowIndex != (input.endIndex - 1) {
        let nextRow = String(input[rowIndex + 1])
        let firstColumnIndex: Substring.Index
        if columnIndex == nextRow.startIndex {
            firstColumnIndex = columnIndex
        } else {
            firstColumnIndex = nextRow.index(before: columnIndex)
        }
        var lastColumnIndex = nextRow.index(after: columnIndex)
        if lastColumnIndex >= nextRow.endIndex {
            lastColumnIndex = nextRow.index(before: nextRow.endIndex)
        }
        let range = firstColumnIndex...lastColumnIndex
        let numbers = extractNumbers(in: range, of: nextRow)
        foundNumbers.append(contentsOf: numbers)
    }

    if foundNumbers.count == 2 {
        return (foundNumbers[0], foundNumbers[1])
    }

    return nil
}

func extractNumbers(from substring: Substring) -> [Int] {
    var result = [Int]()
    var digits = [Character]()
    for index in substring.indices {
        let char = substring[index]
        if char.isNumber {
            digits.append(char)
            let nextIndex = substring.index(after: index)
            if nextIndex >= substring.endIndex || !substring[nextIndex].isNumber {
                result.append(Int(digits.reduce("", { $0 + String($1) }))!)
                digits = []
            }
        }
    }
    return result
}

func extractNumbers(in range: ClosedRange<String.Index>, of string: String) -> [Int] {
    var start = range.lowerBound
    var end = range.upperBound

    // check if range starts with number and prepend numbers before range
    while string[start].isNumber {
        if start == string.startIndex { break }
        start = string.index(before: start)
    }

    // check if range ends with number and prepend numbers after range
    while string[end].isNumber {
        let nextEnd = string.index(after: end)
        if nextEnd == string.endIndex { break }
        end = nextEnd
    }

    return extractNumbers(from: string[start...end])
}

var sum = 0
for (rowIndex, row) in input.enumerated() {
    let row = String(row)
    for (columnIndex, char) in row.enumerated() {
        if char == "*" {
            let charIndex = row.index(row.startIndex, offsetBy: columnIndex)
            let numbers = checkIfStarHasTwoNumbers(rowIndex: rowIndex, columnIndex: charIndex)
            if let numbers {
                sum += numbers.0 * numbers.1
            }
        }
    }
}
print(sum)

