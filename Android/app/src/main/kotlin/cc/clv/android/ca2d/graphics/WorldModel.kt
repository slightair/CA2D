package cc.clv.android.ca2d.graphics

import cc.clv.android.ca2d.World

class WorldModel(world: World) {
    private val world = world

    fun positions(): Array<Position> {
        val cellWidth = 2.0f / world.width.toFloat()
        val cellHeight = 2.0f / world.height.toFloat()

        var positions: Array<Position> = arrayOf()

        for (y in (0..(world.height - 1))) {
            for (x in (0..(world.width - 1))) {
                val condition = world.cells[y * world.width + x]

                if (condition == 0) {
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
            }
        }

        return positions
    }

    fun colors(): Array<Color> {
        var colors: Array<Color> = arrayOf()

        for (condition in world.cells) {
            if (condition == 0) {
                continue
            }
            val color = colorFromCondition(condition)
            colors += Array(6, { color })
        }

        return colors
    }

    fun colorFromCondition(condition: Int): Color {
        return Color(1.0f, 1.0f, 0.0f)
    }
}