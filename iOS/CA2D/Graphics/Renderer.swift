import GLKit
import OpenGLES

class Renderer: NSObject, GLKViewDelegate {
    let context: EAGLContext
    let worldModel: WorldModel

    var modelVertexArray: GLuint = 0
    var modelVertexBuffer: GLuint = 0
    var shaderProgram: ShaderProgram!

    deinit {
        tearDownGL()
    }

    init(context: EAGLContext, world: World) {
        self.context = context
        self.worldModel = WorldModel(world: world)

        super.init()

        setUpGL()
    }

    func setUpGL() {
        EAGLContext.setCurrentContext(context)

        shaderProgram = ShaderProgram(shaderName: "Shader")

        glGenVertexArrays(1, &modelVertexArray)
        glBindVertexArray(modelVertexArray)

        glGenBuffers(1, &modelVertexBuffer)

        glBindVertexArray(0)
    }

    func tearDownGL() {
        glDeleteBuffers(1, &modelVertexBuffer)
        glDeleteVertexArrays(1, &modelVertexArray)
    }

    func renderWorld() {
        func offset(i: Int) -> UnsafePointer<Void> {
            let p: UnsafePointer<Void> = nil
            return p.advancedBy(i)
        }

        let vertices = worldModel.vertices.map { $0.v }

        glBindVertexArray(modelVertexArray)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), modelVertexBuffer)

        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(Vertex.size * worldModel.triangleCount), vertices, GLenum(GL_STREAM_DRAW))

        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(Vertex.size), offset(0))

        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(Vertex.size), offset(sizeof(Float) * 3))

        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(worldModel.triangleCount))

        glBindVertexArray(0)
    }

    // MARK: - GLKView delegate methods

    func glkView(view: GLKView, drawInRect rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE))

        renderWorld()
    }
}
