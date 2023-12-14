import Foundation

func part1() throws {
    let input = try String(contentsOf: Bundle.module.url(
        forResource: "input", withExtension: "txt", subdirectory: nil)!
    ).split(separator: "\n")
    
    var sum = 0
    for line in input {
        let values = line.split(separator: " ").compactMap { Int($0) }
        var steps: [[Int]] = [values]
        while true {
            let previousStep = steps.last!
            var step = [Int]()
            for index in 0..<previousStep.count where index != previousStep.startIndex {
                let previous = previousStep[index - 1]
                let current = previousStep[index]
                let difference = current - previous
                step.append(difference)
            }
            steps.append(step)
            if step.allSatisfy({ $0 == 0 }) { break }
        }
        for index in (0..<steps.count).reversed() {
            if index != steps.endIndex - 1 {
                steps[index].append(steps[index].last! + steps[index + 1].last!)
            } else {
                steps[index].append(steps[index].last! + 0)
            }
        }
        sum += steps.first?.last ?? 0
    }
    print(sum)
}
