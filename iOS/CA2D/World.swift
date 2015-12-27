import Foundation

class World {
    static let width = 4
    static let height = 4

    var cells: [Int]

    init() {
        cells = (0..<(World.width * World.height)).map { _ in Int(arc4random_uniform(2)) }
        print(cells)
    }
}
