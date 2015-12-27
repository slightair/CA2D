import OpenGLES
import GLKit

class WorldModel {
    let world: World

    var vertices: [Vertex] {
        return []
    }

    var triangleCount: Int {
        return world.cells.count * 2
    }

    init(world: World) {
        self.world = world
    }
}
