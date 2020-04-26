import Metal
import MetalKit

struct Vertex {
    var position: SIMD2<Float>
    var color: SIMD3<Float>
}

struct Uniforms {
    var viewportSize: SIMD2<Float>
}

final class Renderer: NSObject {
    private let device: MTLDevice
    private var pipelineState: MTLRenderPipelineState
    private let commandQueue: MTLCommandQueue
    private var drawableSize: CGSize = .zero
    private let world: World
    private let cellSize: CGFloat

    init?(view: MTKView, world: World, cellSize: CGFloat) {
        self.device = view.device!
        self.world = world
        self.cellSize = cellSize

        guard let defaultLibrary = device.makeDefaultLibrary() else {
            fatalError()
        }
        let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = "World Rendering Pipeline"
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }

        commandQueue = device.makeCommandQueue()!
    }

    private func vertexColor(for condition: Int) -> SIMD3<Float> {
        guard world.rule.conditions > 2 else {
            return SIMD3(1.0, 1.0, 0.0)
        }

        let cyan:Float = 0.0
        let magenta:Float = 1.0 - (1.0 / Float(world.rule.conditions - 2) * Float(condition - 1))
        let yellow:Float = 1.0
        let key:Float = 0.0

        let red   = 1 - min(1.0, cyan    * (1.0 - key)) + key
        let green = 1 - min(1.0, magenta * (1.0 - key)) + key
        let blue  = 1 - min(1.0, yellow  * (1.0 - key)) + key

        return SIMD3(red, green, blue)
    }

    private func renderWorld(renderEncoder: MTLRenderCommandEncoder) {
        let cellSize = Float(self.cellSize)
        let basePositionX = Float(-drawableSize.width / 2)
        let basePositionY = Float(-drawableSize.height / 2)

        var vertices: [Vertex] = []

        for y in (0..<world.height) {
            for x in (0..<world.width) {
                let index = y * world.width + x
                let condition = world.cells[index]
                if condition == 0 { continue }

                let color = vertexColor(for: condition)
                let x1 = basePositionX + cellSize * Float(x)
                let x2 = basePositionX + cellSize * Float(x + 1)
                let y1 = basePositionY + cellSize * Float(y)
                let y2 = basePositionY + cellSize * Float(y + 1)

                vertices.append(contentsOf: [
                    Vertex(position: .init(x1, y1), color: color),
                    Vertex(position: .init(x1, y2), color: color),
                    Vertex(position: .init(x2, y1), color: color),
                    Vertex(position: .init(x1, y2), color: color),
                    Vertex(position: .init(x2, y1), color: color),
                    Vertex(position: .init(x2, y2), color: color),
                ])
            }
        }

        let vertexBuffer = device.makeBuffer(bytes: vertices,
                                             length: vertices.count * MemoryLayout<Vertex>.stride,
                                             options: [])!
        var uniforms = Uniforms(viewportSize: .init(Float(drawableSize.width), Float(drawableSize.height)))

        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBytes(&uniforms,
                                     length: MemoryLayout<Uniforms>.stride,
                                     index: 1)

        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        drawableSize = size
    }

    func draw(in view: MTKView) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.label = "World Command Buffer"

        if let renderPassDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
            renderEncoder.label = "World Render Encoder"

            let viewport = MTLViewport(originX: 0,
                                       originY: 0,
                                       width: Double(drawableSize.width),
                                       height: Double(drawableSize.height),
                                       znear: 0,
                                       zfar: 1)
            renderEncoder.setViewport(viewport)
            renderEncoder.setRenderPipelineState(pipelineState)

            renderWorld(renderEncoder: renderEncoder)

            renderEncoder.endEncoding()

            if let drawable = view.currentDrawable {
                commandBuffer.present(drawable)
            }
        }
        commandBuffer.commit()
    }
}
