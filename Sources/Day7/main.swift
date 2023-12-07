import Foundation

let input = try String(contentsOf: Bundle.module.url(
    forResource: "input", withExtension: "txt", subdirectory: nil)!
).split(separator: "\n")

var handsWithBids: [(hand: Substring, bid: Int)] = input.map { raw in
    let parts = raw.split(separator: " ")
    return (parts[0], Int(parts[1])!)
}

let cardRanks: [Character] = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

enum HandType: Int, Comparable {
    static func < (lhs: HandType, rhs: HandType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case fiveKind
    case fourKind
    case fullHouse
    case threeKind
    case twoPair
    case onePair
    case highCard
}

func getType(hand: Substring) -> HandType {
    var count = [Int](repeating: 0, count: 13)
    for character in hand {
        switch character {
        case "A": count[0] += 1
        case "K": count[1] += 1
        case "Q": count[2] += 1
        case "J": count[3] += 1
        case "T": count[4] += 1
        case "9": count[5] += 1
        case "8": count[6] += 1
        case "7": count[7] += 1
        case "6": count[8] += 1
        case "5": count[9] += 1
        case "4": count[10] += 1
        case "3": count[11] += 1
        case "2": count[12] += 1
        default: fatalError("unknown character \(character)")
        }
    }

    let jCount = count[3]
    count[3] = 0
    var indexOfMax = 0
    for indexOfCount in 0..<13 {
        if count[indexOfMax] < count[indexOfCount] {
            indexOfMax = indexOfCount
        }
    }
    count[indexOfMax] += jCount

    var countOfCounts = [Int](repeating: 0, count: 5)

    for c in count {
        if c == 0 { continue }
        countOfCounts[c - 1] += 1
    }

    if countOfCounts[4] == 1 {
        return .fiveKind
    } else if countOfCounts[3] == 1 && countOfCounts[0] == 1 {
        return .fourKind
    } else if countOfCounts[2] == 1 && countOfCounts[1] == 1 {
        return .fullHouse
    } else if countOfCounts[2] == 1 && countOfCounts[0] == 2 {
        return .threeKind
    } else if countOfCounts[1] == 2 && countOfCounts[0] == 1 {
        return .twoPair
    } else if countOfCounts[1] == 1 && countOfCounts[0] == 3 {
        return .onePair
    }
    return .highCard
}

handsWithBids.sort(by: { lhs, rhs in
    let lhsHand = lhs.hand
    let lhsHandType = getType(hand: lhsHand)
    
    let rhsHand = rhs.hand
    let rhsHandType = getType(hand: rhsHand)

    if lhsHandType == rhsHandType {
        for i in 0..<5 {
            let lhsIndex = lhsHand.index(lhsHand.startIndex, offsetBy: i)
            let rhsIndex = rhsHand.index(rhsHand.startIndex, offsetBy: i)
            if lhsHand[lhsIndex] != rhsHand[rhsIndex] {
                var lhsHandCardRank = 0
                for indexCardRanking in 0..<13 {
                    if cardRanks[indexCardRanking] == lhsHand[lhsIndex] {
                        lhsHandCardRank = indexCardRanking
                        break
                    }
                }
                var rhsHandCardRank = 0
                for indexCardRanking in 0..<13 {
                    if cardRanks[indexCardRanking] == rhsHand[rhsIndex] {
                        rhsHandCardRank = indexCardRanking
                        break
                    }
                }
                return lhsHandCardRank > rhsHandCardRank
            }
        }
    }

    return lhsHandType > rhsHandType
})

var sum = 0
for index in 0..<handsWithBids.count {
    sum += (index + 1) * handsWithBids[index].bid
}
print(sum)
