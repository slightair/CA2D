import UIKit
import GLKit
import Chameleon

final class GameViewController: GLKViewController {
    var renderer: Renderer!
    var world: World!
    var timer: NSTimer?
    var playBarButtonItem: UIBarButtonItem!
    var pauseBarButtonItem: UIBarButtonItem!
    var presetToolbarItems: [UIBarButtonItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = EAGLContext(API: .OpenGLES3)

        let nativeBounds = UIScreen.mainScreen().nativeBounds
        let split = 4 * UIScreen.mainScreen().scale
        let worldWidth = Int(CGRectGetHeight(nativeBounds) / split)
        let worldHeight = Int(CGRectGetWidth(nativeBounds) / split)
        let selectedRule = Rule.presets.first!
        world = World(width: worldWidth, height: worldHeight, rule: selectedRule)

        renderer = Renderer(context: context, world: world)

        let glkView = view as! GLKView
        glkView.delegate = renderer
        glkView.context = context
        glkView.drawableColorFormat = .SRGBA8888
        glkView.drawableDepthFormat = .Format24

        self.title = selectedRule.name

        setUpBars()

        world.shuffle()
    }

    func setUpBars() {
        let barTintColor = UIColor.flatBlackColor()

        navigationController?.navigationBar.barTintColor = barTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.flatWhiteColor()]

        navigationController?.toolbar.barTintColor = barTintColor
        navigationController?.toolbar.tintColor = UIColor.flatGrayColor()

        playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "didPressPlayButton:")
        pauseBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "didPressPauseButton:")

        presetToolbarItems = toolbarItems
        toolbarItems = [playBarButtonItem] + presetToolbarItems!
    }

    deinit {
        pauseWorld()
    }

    func tickWorld() {
        world.tick()
    }

    func startWorld() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0 / 20, target: self, selector: "tickWorld", userInfo: nil, repeats: true)
    }

    func pauseWorld() {
        timer?.invalidate()
        timer = nil
    }

    func didPressPlayButton(sender: AnyObject?) {
        startWorld()

        toolbarItems = [pauseBarButtonItem] + presetToolbarItems!
    }

    func didPressPauseButton(sender: AnyObject?) {
        pauseWorld()

        toolbarItems = [playBarButtonItem] + presetToolbarItems!
    }
}
