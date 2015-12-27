import GLKit

class GameViewController: GLKViewController {
    var renderer: Renderer!
    let world = World()

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = EAGLContext(API: .OpenGLES3)
        renderer = Renderer(context: context, world: world)

        let glkView = view as! GLKView
        glkView.delegate = renderer
        glkView.context = context
        glkView.drawableColorFormat = .SRGBA8888
        glkView.drawableDepthFormat = .Format24
    }

    func update() {

    }
}
