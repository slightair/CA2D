import UIKit
import MetalKit

final class GameViewController: UIViewController {
    var renderer: Renderer!
    var world: World!
    var timer: Timer?
    var playBarButtonItem: UIBarButtonItem!
    var pauseBarButtonItem: UIBarButtonItem!
    var presetToolbarItems: [UIBarButtonItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedRule = Rule.presets.first!
        self.title = selectedRule.name

        let nativeBounds = UIScreen.main.nativeBounds
        let cellSize = 4 * UIScreen.main.scale
        let worldWidth = Int(ceil(nativeBounds.height / cellSize))
        let worldHeight = Int(ceil(nativeBounds.width / cellSize))

        world = World(width: worldWidth, height: worldHeight, rule: selectedRule)
        world.delegate = self
        world.shuffle()

        setUpMetal(cellSize: cellSize)
        setUpBars()
    }

    private func setUpMetal(cellSize: CGFloat) {
        guard let mtkView = view as? MTKView else {
            fatalError("view is not MTKView")
        }

        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }

        mtkView.device = defaultDevice
        mtkView.backgroundColor = .black

        guard let renderer = Renderer(view: mtkView, world: world, cellSize: cellSize) else {
            fatalError("Renderer cannot be initialized")
        }

        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        self.renderer = renderer

        mtkView.delegate = renderer
    }

    private func setUpBars() {
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

    @objc private func tickWorld() {
        world.tick()
    }

    private func startWorld() {
        timer = Timer.scheduledTimer(timeInterval: 1.0 / 20, target: self, selector: #selector(tickWorld), userInfo: nil, repeats: true)

        toolbarItems = [pauseBarButtonItem] + presetToolbarItems!
    }

    private func pauseWorld() {
        timer?.invalidate()
        timer = nil

        toolbarItems = [playBarButtonItem] + presetToolbarItems!
    }

    @objc private func didPressPlayButton(sender: AnyObject?) {
        startWorld()
    }

    @objc private func didPressPauseButton(sender: AnyObject?) {
        pauseWorld()
    }
}

extension GameViewController: WorldDelegate {
    func world(_ world: World, didChangeRule rule: Rule) {
        self.title = rule.name
    }
}
