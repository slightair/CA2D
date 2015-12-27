import GLKit

struct Vertex {
    static let size = sizeof(Float) * 7

    let position: GLKVector3
    let color: GLKVector4

    var v: [Float] {
        return [
            position.x,
            position.y,
            position.z,
            color.r,
            color.g,
            color.b,
            color.a,
        ]
    }
}
