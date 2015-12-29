import Foundation

final class World {
    let width, height: Int
    var rule: Rule {
        didSet {
            shuffle()
        }
    }
    var cells: [Int]

    init(width: Int, height: Int, rule: Rule) {
        self.width = width
        self.height = height
        self.rule = rule
        self.cells = [Int](count: width * height, repeatedValue: 0)
    }

    func shuffle() {
        let rate = 0.1
        cells = (0..<(width * height)).map { _ in Double(arc4random_uniform(1000)) / 1000.0 < rate ? rule.conditions : 0 }
    }

    func tick() {
        var nextCells = [Int](count: self.width * self.height, repeatedValue: 0)
        let condMax = rule.conditions - 1

        func index(idx: (Int, Int)) -> Int {
            let (x, y) = idx
            let adjustX = (x + width) % width
            let adjustY = (y + height) % height
            return adjustY * width + adjustX
        }

        for y in 0..<self.height {
            for x in 0..<self.width {
                let indexes = [
                    (x - 1, y - 1), (x, y - 1), (x + 1, y - 1),
                    (x - 1, y    ),             (x + 1, y    ),
                    (x - 1, y + 1), (x, y + 1), (x + 1, y + 1),
                ]
                let count = indexes.map { self.cells[index($0)] == condMax ? 1 : 0 }.reduce(0){ $0 + $1 }
                let env = 1 << count
                let idx = index((x, y))
                let prevCond = self.cells[idx]

                if prevCond == 0 && (self.rule.born & env) > 0 {
                    nextCells[idx] = condMax
                } else if prevCond == condMax && (self.rule.survive & env) > 0 {
                    nextCells[idx] = condMax
                } else {
                    if prevCond > 0 {
                        nextCells[idx] = prevCond - 1
                    }
                }
            }
        }
        self.cells = nextCells
    }
}
