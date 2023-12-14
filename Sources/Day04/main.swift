import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

var sum = 0
var factors = [Int](repeating: 1, count: input.count)

for (index, line) in input.enumerated() {
    let factor = factors[index]
    let parts = line.split(separator: ": ")[1].split(separator: " | ")
    let winningNumbers = parts[0].split(separator: " ").compactMap { Int($0) }
    let yours = parts[1].split(separator: " ").compactMap { Int($0) }
    let winCount = yours.filter { winningNumbers.contains($0) }.count
    for i in index..<(index + winCount) {
        factors[i + 1] += factor
    }
    sum += factor * winCount + 1
}

print(sum)
