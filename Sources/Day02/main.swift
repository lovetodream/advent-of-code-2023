import Foundation
import RegexBuilder

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)
.split(separator: "\n")

let gameIDRegex = Regex {
    "Game "
    Capture {
        OneOrMore(.digit)
    } transform: { w in
        Int(w)!
    }
    ": "
}

let grabRegex = Regex {
    Capture {
        OneOrMore(.digit)
    } transform: { w in
        Int(w)!
    }
    One(.horizontalWhitespace)
    Capture {
        OneOrMore(.word)
    } transform: { w in
        String(w)
    }
}

var result = 0
for line in input {
    let gameID = line.firstMatch(of: gameIDRegex)!.1
    let sets = line.replacing(gameIDRegex, with: "").split(separator: "; ")
    var minimum = ["red": 0, "green": 0, "blue": 0]
    for set in sets {
        let grabs = set.split(separator: ", ")
        for grab in grabs {
            let match = grab.firstMatch(of: grabRegex)!
            let amount = match.1
            let color = match.2
            if minimum[color]! < amount {
                minimum[color]! = amount
            }
        }
    }
    let power = minimum["red"]! * minimum["green"]! * minimum["blue"]!
    result += power
}
print(result)
