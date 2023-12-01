import Foundation
import RegexBuilder

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
)
.split(separator: "\n")

var result = 0
let regex = Regex {
    Capture {
        ChoiceOf {
            One(.digit)
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "seven"
            "eight"
            "nine"
        }
    } transform: { w in
        switch w {
        case "1", "one": "1"
        case "2", "two": "2"
        case "3", "three": "3"
        case "4", "four": "4"
        case "5", "five": "5"
        case "6", "six": "6"
        case "7", "seven": "7"
        case "8", "eight": "8"
        case "9", "nine": "9"
        default: ""
        }
    }
}
for var line in input {
    let first = line.firstMatch(of: regex)?.1 ?? ""
    var potentialLast = [String]()
    while line.count > 0 {
        if let last = line.firstMatch(of: regex)?.1 {
            potentialLast.append(last)
        }
        line = line.dropFirst()
    }
    guard let num = Int(first + (potentialLast.last ?? first)) else { fatalError(String(line)) }
    result += num
}
print("final: \(result)")
