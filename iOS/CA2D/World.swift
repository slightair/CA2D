import Foundation

class World {
    let width: Int
    let height: Int
    var cells: [Int]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.cells = [Int](count: width * height, repeatedValue: 0)
    }

    func shuffle() {
        cells = (0..<(width * height)).map { _ in Int(arc4random_uniform(2)) }
    }
}
