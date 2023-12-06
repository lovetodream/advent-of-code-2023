import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

let time = Int(input[0].replacingOccurrences(of: "Time:", with: "").replacingOccurrences(of: " ", with: ""))!
let distance = Int(input[1].replacingOccurrences(of: "Distance:", with: "").replacingOccurrences(of: " ", with: ""))!

var firstWin = 0
var lastWin = 0
for hold in 0...time {
    if canBeatRecord(distance, withHold: hold, inTime: time) {
        firstWin = hold
        break
    }
}

for hold in (0...time).reversed() {
    if canBeatRecord(distance, withHold: hold, inTime: time) {
        lastWin = hold
        break
    }
}

let winningWays = (firstWin...lastWin).count
print(winningWays)

func canBeatRecord(_ record: Int, withHold hold: Int, inTime time: Int) -> Bool {
    let difference = time - hold
    let distance = hold * difference
    return distance > record
}
