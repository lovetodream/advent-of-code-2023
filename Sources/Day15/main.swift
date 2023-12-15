import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).replacingOccurrences(of: "\n", with: "").split(separator: ",")

var boxes: [[[Substring]]] = Array(repeating: [], count: 256)
for sequence in input {
    let splits = sequence.split { "=-".contains($0) }
    let boxIndex = hash(splits[0])
    modify(box: &boxes[boxIndex], splits: splits)
}
let power = boxes.enumerated().reduce(0) { sum, box in
    box.1.enumerated().reduce(sum) {
        $0 + (box.0 + 1) * ($1.0 + 1) * Int($1.1.last!)!
    }
}
print(power)

func modify(box: inout [[Substring]], splits: [Substring]) {
    if splits.count == 1 { box.removeAll { $0[0] == splits[0] } }
    else {
        for (index, part) in box.enumerated() {
            if part[0] == splits[0] { return box[index] = splits  }
        }
        box.append(splits)
    }
}

@inlinable
func hash<T: StringProtocol>(_ value: T) -> Int {
    var hash = 0
    for character in value {
        hash += Int(character.asciiValue!)
        hash *= 17
        hash = hash % 256
    }
    return hash
}
