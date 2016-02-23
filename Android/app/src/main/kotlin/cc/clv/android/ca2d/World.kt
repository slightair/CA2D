package cc.clv.android.ca2d

import java.util.*

class World(width: Int, height: Int, rule: Rule) {
    val width = width
    val height = height
    var rule = rule
        set(value) {
            shuffle()
        }
    var cells = IntArray(width * height)

    init {
        shuffle()
    }

    fun shuffle() {
        val random = Random()
        val rate = 0.1

        for (i in 0..(width * height - 1)) {
            cells[i] = if (random.nextDouble() < rate) rule.conditions - 1 else 0
        }
    }

    fun tick() {
        var nextCells = IntArray(width * height)
        val condMax = rule.conditions - 1

        fun index(pair: Pair<Int, Int>): Int {
            val (x, y) = pair
            val adjustX = (x + width) % width
            val adjustY = (y + height) % height

            return adjustY * width + adjustX
        }

        for (y in 0..(height - 1)) {
            for (x in 0..(width - 1)) {
                val indexes = arrayOf(
                        Pair(x - 1, y - 1), Pair(x, y - 1), Pair(x + 1, y - 1),
                        Pair(x - 1, y), /*     self      */ Pair(x + 1, y),
                        Pair(x - 1, y + 1), Pair(x, y + 1), Pair(x + 1, y + 1)
                )
                val count = indexes.map { if (cells[index(it)] == condMax) 1 else 0 }.sum()
                val env = 1 shl count
                val idx = index(Pair(x, y))
                val prevCond = cells[idx]

                if (prevCond == 0 && (rule.born and env) > 0) {
                    nextCells[idx] = condMax
                } else if (prevCond == condMax && (rule.survive and env) > 0) {
                    nextCells[idx] = condMax
                } else {
                    if (prevCond > 0) {
                        nextCells[idx] = prevCond - 1
                    }
                }
            }
        }
        cells = nextCells
    }
}
