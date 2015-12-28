import Foundation

class World {
    let width: Int
    let height: Int
    let rule: Rule
    var cells: [Int]

    init(width: Int, height: Int, rule: Rule) {
        self.width = width
        self.height = height
        self.rule = rule
        self.cells = [Int](count: width * height, repeatedValue: 0)
    }

    func shuffle() {
        cells = (0..<(width * height)).map { _ in Int(arc4random_uniform(2)) }
    }
}
