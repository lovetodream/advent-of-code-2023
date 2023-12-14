import Foundation
import RegexBuilder

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")
    
    func checkIfNumberHasNeighbor(
        rowIndex: [String.SubSequence].Index,
        startColumnIndex: String.SubSequence.Index,
        digits: Int
    ) -> Bool {
        let row = String(input[rowIndex])
        
        // check previous char
        if startColumnIndex != row.startIndex {
            let previousColumnIndex = row.index(before: startColumnIndex)
            if row[previousColumnIndex] != "." {
                return true
            }
        }
        
        // check following char
        if row.index(startColumnIndex, offsetBy: digits - 1) != row.endIndex {
            let nextColumnIndex = row.index(startColumnIndex, offsetBy: digits)
            if nextColumnIndex < row.endIndex && row[nextColumnIndex] != "." {
                return true
            }
        }
        
        // check previous row
        if rowIndex != input.startIndex {
            let previousRow = String(input[rowIndex - 1])
            let firstColumnIndex: Substring.Index
            if startColumnIndex == previousRow.startIndex {
                firstColumnIndex = startColumnIndex
            } else {
                firstColumnIndex = previousRow.index(before: startColumnIndex)
            }
            var lastColumnIndex = previousRow.index(startColumnIndex, offsetBy: digits)
            if lastColumnIndex >= previousRow.endIndex {
                lastColumnIndex = previousRow.index(before: previousRow.endIndex)
            }
            let neighbors = previousRow[firstColumnIndex...lastColumnIndex]
            for neighbor in neighbors {
                if neighbor != "." {
                    return true
                }
            }
        }
        
        // check next row
        if rowIndex != (input.endIndex - 1) {
            let nextRow = String(input[rowIndex + 1])
            let firstColumnIndex: Substring.Index
            if startColumnIndex == nextRow.startIndex {
                firstColumnIndex = startColumnIndex
            } else {
                firstColumnIndex = nextRow.index(before: startColumnIndex)
            }
            var lastColumnIndex = nextRow.index(startColumnIndex, offsetBy: digits)
            if lastColumnIndex >= nextRow.endIndex {
                lastColumnIndex = nextRow.index(before: nextRow.endIndex)
            }
            let neighbors = nextRow[firstColumnIndex...lastColumnIndex]
            for neighbor in neighbors {
                if neighbor != "." {
                    return true
                }
            }
        }
        
        return false
    }
    
    var sum = 0
    for (rowIndex, row) in input.enumerated() {
        let row = String(row)
        var digits: [Character] = []
        var firstDigitIndex: Substring.Index?
        for (columnIndex, char) in row.enumerated() {
            if char.isNumber {
                digits.append(char)
                if firstDigitIndex == nil {
                    firstDigitIndex = row.index(row.startIndex, offsetBy: columnIndex)
                }
                // check if next char is a number too
                let nextIndex = row.index(row.startIndex, offsetBy: columnIndex + 1)
                if nextIndex >= row.endIndex || !row[nextIndex].isNumber {
                    let hasNeighbors = checkIfNumberHasNeighbor(rowIndex: rowIndex, startColumnIndex: firstDigitIndex!, digits: digits.count)
                    if hasNeighbors {
                        sum += Int(digits.reduce("", { partialResult, char in
                            partialResult + String(char)
                        }))!
                    }
                    firstDigitIndex = nil
                    digits = []
                }
                
            }
        }
    }
    print(sum)
}
