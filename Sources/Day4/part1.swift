import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")

    var sum = 0
    for line in input {
        let parts = line.split(separator: ": ")[1].split(separator: " | ")
        let winningNumbers = parts[0].split(separator: " ").compactMap { Int($0) }
        let yours = parts[1].split(separator: " ").compactMap { Int($0) }
        var yourWinningNumbersCount = 0
        for winningNumber in winningNumbers {
            if yours.contains(winningNumber) {
                if yourWinningNumbersCount == 0 {
                    yourWinningNumbersCount = 1
                } else {
                    yourWinningNumbersCount *= 2
                }
            }
        }
        sum += yourWinningNumbersCount
    }
    print(sum)
}
