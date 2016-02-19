package cc.clv.android.ca2d

import java.util.*

class World(width: Int, height: Int) {
    val width = width
    val height = height
    var cells = IntArray(width * height)

    init {
        shuffle()
    }

    fun shuffle() {
        val random = Random()
        val rate = 0.1

        for (i in 0..(width * height - 1)) {
            cells[i] = if (random.nextDouble() < rate) 1 else 0
        }
    }
}
