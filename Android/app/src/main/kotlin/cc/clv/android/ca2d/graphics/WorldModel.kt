package cc.clv.android.ca2d.graphics

import cc.clv.android.ca2d.World

class WorldModel(world: World) {
    private val world = world
    val maxVertexCount: Int get() = world.width * world.height * 6

    fun vertices(): Pair<Array<Position>, Array<Color>> {
        val cellWidth = 2.0f / world.width.toFloat()
        val cellHeight = 2.0f / world.height.toFloat()

        var positions: Array<Position> = arrayOf()
        var colors: Array<Color> = arrayOf()

        for (y in (0..(world.height - 1))) {
            for (x in (0..(world.width - 1))) {
                val condition = world.cells[y * world.width + x]

                if (condition == 0.toByte()) {
                    continue
                }

                val posA = Position(-1.0f + cellWidth * x.toFloat(), -1.0f + cellHeight * y.toFloat())
                val posB = Position(-1.0f + cellWidth * x.toFloat(), -1.0f + cellHeight * (y + 1).toFloat())
                val posC = Position(-1.0f + cellWidth * (x + 1).toFloat(), -1.0f + cellHeight * y.toFloat())
                val posD = Position(-1.0f + cellWidth * (x + 1).toFloat(), -1.0f + cellHeight * (y + 1).toFloat())

                positions += arrayOf(
                        posA, posB, posC,
                        posB, posC, posD
                )

                val color = colorFromCondition(condition)
                colors += Array(6, { color })
            }
        }

        return Pair(positions, colors)
    }

    fun colorFromCondition(condition: Byte): Color {
        if (world.rule.conditions <= 2) {
            return Color(1.0f, 1.0f, 0.0f)
        }

        val cyan = 0.0f
        val magenta = 1.0f - (1.0f / (world.rule.conditions - 2).toFloat() * (condition - 1).toFloat())
        val yellow = 1.0f
        val key = 0.0f

        val red = 1.0f - arrayOf(1.0f, cyan * (1.0f - key)).min()!! + key
        val green = 1.0f - arrayOf(1.0f, magenta * (1.0f - key)).min()!! + key
        val blue = 1.0f - arrayOf(1.0f, yellow * (1.0f - key)).min()!! + key

        return Color(red, green, blue)
    }
}
