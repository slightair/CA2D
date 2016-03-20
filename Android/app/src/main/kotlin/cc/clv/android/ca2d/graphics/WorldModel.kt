package cc.clv.android.ca2d.graphics

import cc.clv.android.ca2d.World
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer

class WorldModel(world: World) {
    companion object {
        val PositionSize = 4 * 2
        val ColorSize = 4 * 3
    }

    private val world = world
    private val maxVertexCount: Int
        get() = world.width * world.height * 6

    var vertexCount: Int = 0
    var positionBuffer: FloatBuffer
    var colorBuffer: FloatBuffer

    init {
        positionBuffer = ByteBuffer.allocateDirect(maxVertexCount * PositionSize)
                .order(ByteOrder.nativeOrder()).asFloatBuffer()
        colorBuffer = ByteBuffer.allocateDirect(maxVertexCount * ColorSize)
                .order(ByteOrder.nativeOrder()).asFloatBuffer()
    }

    fun update() {
        positionBuffer.clear()
        colorBuffer.clear()
        vertexCount = 0

        val cellWidth = 2.0f / world.width.toFloat()
        val cellHeight = 2.0f / world.height.toFloat()
        val colors = (0..world.rule.conditions).map { colorFromCondition(it) }

        for (y in (0..(world.height - 1))) {
            for (x in (0..(world.width - 1))) {
                val condition = world.cells[y * world.width + x]

                if (condition == 0.toByte()) {
                    continue
                }

                val posA = floatArrayOf(-1.0f + cellWidth * x.toFloat(), -1.0f + cellHeight * y.toFloat())
                val posB = floatArrayOf(-1.0f + cellWidth * x.toFloat(), -1.0f + cellHeight * (y + 1).toFloat())
                val posC = floatArrayOf(-1.0f + cellWidth * (x + 1).toFloat(), -1.0f + cellHeight * y.toFloat())
                val posD = floatArrayOf(-1.0f + cellWidth * (x + 1).toFloat(), -1.0f + cellHeight * (y + 1).toFloat())

                val color = colors[condition.toInt()]

                positionBuffer.put(posA)
                colorBuffer.put(color)

                positionBuffer.put(posB)
                colorBuffer.put(color)

                positionBuffer.put(posC)
                colorBuffer.put(color)

                positionBuffer.put(posB)
                colorBuffer.put(color)

                positionBuffer.put(posC)
                colorBuffer.put(color)

                positionBuffer.put(posD)
                colorBuffer.put(color)

                vertexCount += 6
            }
        }
    }

    fun colorFromCondition(condition: Int): FloatArray {
        if (world.rule.conditions <= 2) {
            return floatArrayOf(1.0f, 1.0f, 0.0f)
        }

        val cyan = 0.0f
        val magenta = 1.0f - (1.0f / (world.rule.conditions - 2).toFloat() * (condition - 1).toFloat())
        val yellow = 1.0f
        val key = 0.0f

        val red = 1.0f - arrayOf(1.0f, cyan * (1.0f - key)).min()!! + key
        val green = 1.0f - arrayOf(1.0f, magenta * (1.0f - key)).min()!! + key
        val blue = 1.0f - arrayOf(1.0f, yellow * (1.0f - key)).min()!! + key

        return floatArrayOf(red, green, blue)
    }
}
