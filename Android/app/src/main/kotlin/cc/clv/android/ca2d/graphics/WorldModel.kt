package cc.clv.android.ca2d.graphics

import cc.clv.android.ca2d.World

class WorldModel(world: World) {
    private val world = world
    val maxVertexCount: Int get() = world.width * world.height * 6

    fun vertexAttribSet(): VertexAttribSet {
        val cellWidth = 2.0f / world.width.toFloat()
        val cellHeight = 2.0f / world.height.toFloat()

        var positions = floatArrayOf()
        var colors = floatArrayOf()

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

                positions += posA
                positions += posB
                positions += posC

                positions += posB
                positions += posC
                positions += posD

                val color = colorFromCondition(condition)
                for (i in 0..5) {
                    colors += color
                }
            }
        }

        return VertexAttribSet(world.cells.size * 6, positions, colors)
    }

    fun colorFromCondition(condition: Byte): FloatArray {
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
