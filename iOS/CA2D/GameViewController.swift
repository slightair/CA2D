import GLKit

class GameViewController: GLKViewController {
    var renderer: Renderer!
    var world: World!
    var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = EAGLContext(API: .OpenGLES3)

        let nativeBounds = UIScreen.mainScreen().nativeBounds
        let split = 4 * UIScreen.mainScreen().scale
        let worldWidth = Int(CGRectGetHeight(nativeBounds) / split)
        let worldHeight = Int(CGRectGetWidth(nativeBounds) / split)
        world = World(width: worldWidth, height: worldHeight, rule: Rule.presets.first!)

        renderer = Renderer(context: context, world: world)

        let glkView = view as! GLKView
        glkView.delegate = renderer
        glkView.context = context
        glkView.drawableColorFormat = .SRGBA8888
        glkView.drawableDepthFormat = .Format24

        world.shuffle()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0 / 20, target: self, selector: "tickWorld", userInfo: nil, repeats: true)
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    func tickWorld() {
        world.tick()
    }
}
