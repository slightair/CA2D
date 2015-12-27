import OpenGLES
import GLKit

class WorldModel {
    let world: World

    var vertices: [Vertex] {
        let cellWidth = 2.0 / Float(world.width)
        let cellHeight = 2.0 / Float(world.height)

        var vertices: [Vertex] = []

        for y in (0..<world.height) {
            for x in (0..<world.width) {
                let cell = world.cells[y * world.width + x]
                if cell == 0 {
                    continue
                }

                let color = GLKVector3Make(1.0, 1.0, 0.0)

                let posA = GLKVector2Make(-1.0 + cellWidth * Float(x),     -1.0 + cellHeight * Float(y))
                let posB = GLKVector2Make(-1.0 + cellWidth * Float(x),     -1.0 + cellHeight * Float(y + 1))
                let posC = GLKVector2Make(-1.0 + cellWidth * Float(x + 1), -1.0 + cellHeight * Float(y))
                let posD = GLKVector2Make(-1.0 + cellWidth * Float(x + 1), -1.0 + cellHeight * Float(y + 1))

                vertices.appendContentsOf([
                    Vertex(position: posA, color: color),
                    Vertex(position: posB, color: color),
                    Vertex(position: posC, color: color),

                    Vertex(position: posB, color: color),
                    Vertex(position: posC, color: color),
                    Vertex(position: posD, color: color),
                ])
            }
        }

        return vertices
    }

    init(world: World) {
        self.world = world
    }
}
