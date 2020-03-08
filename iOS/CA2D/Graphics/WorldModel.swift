//import OpenGLES
//import GLKit
//
//final class WorldModel {
//    let world: World
//
//    var vertices: [Vertex] {
//        let cellWidth = 2.0 / Float(world.width)
//        let cellHeight = 2.0 / Float(world.height)
//
//        var vertices: [Vertex] = []
//
//        for y in (0..<world.height) {
//            for x in (0..<world.width) {
//                let condition = world.cells[y * world.width + x]
//                if condition == 0 {
//                    continue
//                }
//
//                let color = colorFromCondition(condition)
//
//                let posA = GLKVector2Make(-1.0 + cellWidth * Float(x),     -1.0 + cellHeight * Float(y))
//                let posB = GLKVector2Make(-1.0 + cellWidth * Float(x),     -1.0 + cellHeight * Float(y + 1))
//                let posC = GLKVector2Make(-1.0 + cellWidth * Float(x + 1), -1.0 + cellHeight * Float(y))
//                let posD = GLKVector2Make(-1.0 + cellWidth * Float(x + 1), -1.0 + cellHeight * Float(y + 1))
//
//                vertices.appendContentsOf([
//                    Vertex(position: posA, color: color),
//                    Vertex(position: posB, color: color),
//                    Vertex(position: posC, color: color),
//
//                    Vertex(position: posB, color: color),
//                    Vertex(position: posC, color: color),
//                    Vertex(position: posD, color: color),
//                ])
//            }
//        }
//
//        return vertices
//    }
//
//    init(world: World) {
//        self.world = world
//    }
//
//    func colorFromCondition(condition: Int) -> GLKVector3 {
//        guard world.rule.conditions > 2 else {
//            return GLKVector3Make(1.0, 1.0, 0.0)
//        }
//
//        let cyan:Float = 0.0
//        let magenta:Float = 1.0 - (1.0 / Float(world.rule.conditions - 2) * Float(condition - 1))
//        let yellow:Float = 1.0
//        let key:Float = 0.0
//
//        let red   = 1 - min(1.0, cyan    * (1.0 - key)) + key
//        let green = 1 - min(1.0, magenta * (1.0 - key)) + key
//        let blue  = 1 - min(1.0, yellow  * (1.0 - key)) + key
//
//        return GLKVector3Make(red, green, blue)
//    }
//}
