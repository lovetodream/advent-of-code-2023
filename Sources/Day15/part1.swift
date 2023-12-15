import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).replacingOccurrences(of: "\n", with: "").split(separator: ",")

    var sum = 0
    for sequence in input {
        var hash = 0
        for character in sequence {
            hash += Int(character.asciiValue!)
            hash *= 17
            hash = hash % 256
        }
        sum += hash
    }
    print(sum)
}
