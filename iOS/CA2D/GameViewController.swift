import UIKit
import GLKit

final class GameViewController: GLKViewController, WorldDelegate {
//    var renderer: Renderer!
    var world: World!
    var timer: Timer?
    var playBarButtonItem: UIBarButtonItem!
    var pauseBarButtonItem: UIBarButtonItem!
    var presetToolbarItems: [UIBarButtonItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let nativeBounds = UIScreen.main.nativeBounds
        let split = 4 * UIScreen.main.scale
        let worldWidth = Int(ceil(nativeBounds.height / split))
        let worldHeight = Int(ceil(nativeBounds.width / split))
        let selectedRule = Rule.presets.first!
        world = World(width: worldWidth, height: worldHeight, rule: selectedRule)
        world.delegate = self

//        let context = EAGLContext(API: .OpenGLES3)
//        renderer = Renderer(context: context, world: world)

//        let glkView = view as! GLKView
//        glkView.delegate = renderer
//        glkView.context = context
//        glkView.drawableColorFormat = .SRGBA8888
//        glkView.drawableDepthFormat = .Format24

        self.title = selectedRule.name

        setUpBars()

        world.shuffle()
    }

    func setUpBars() {
        playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didPressPlayButton(sender:)))
        pauseBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(didPressPauseButton(sender:)))

        presetToolbarItems = toolbarItems
        toolbarItems = [playBarButtonItem] + presetToolbarItems!
    }

    deinit {
        pauseWorld()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRules" {
            pauseWorld()

            guard let destinationViewController = segue.destination as? UINavigationController else {
                return
            }

            guard let ruleListViewController = destinationViewController.topViewController as? RuleListViewController else {
                return
            }

            ruleListViewController.world = world
        }
    }

    @objc func tickWorld() {
        world.tick()
    }

    func startWorld() {
        timer = Timer.scheduledTimer(timeInterval: 1.0 / 20, target: self, selector: #selector(tickWorld), userInfo: nil, repeats: true)

        toolbarItems = [pauseBarButtonItem] + presetToolbarItems!
    }

    func pauseWorld() {
        timer?.invalidate()
        timer = nil

        toolbarItems = [playBarButtonItem] + presetToolbarItems!
    }

    @objc func didPressPlayButton(sender: AnyObject?) {
        startWorld()
    }

    @objc func didPressPauseButton(sender: AnyObject?) {
        pauseWorld()
    }

    func world(_ world: World, didChangeRule rule: Rule) {
        self.title = rule.name
    }
}
