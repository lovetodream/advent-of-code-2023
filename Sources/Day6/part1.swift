import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")
    
    let times = input[0].split(separator: " ").compactMap { Int($0) }
    let distances = input[1].split(separator: " ").compactMap { Int($0) }
    
    var sum = 0
    for (index, distance) in distances.enumerated() {
        var winningWays = 0
        let duration = times[index]
        for hold in 0...duration {
            winningWays += canBeatRecord(distance, withHold: hold, inTime: duration) ? 1 : 0
        }
        if sum == 0 {
            sum = winningWays
        } else {
            sum *= winningWays
        }
    }
    print(sum)
    
    func canBeatRecord(_ record: Int, withHold hold: Int, inTime time: Int) -> Bool {
        let difference = time - hold
        let distance = hold * difference
        return distance > record
    }
}
