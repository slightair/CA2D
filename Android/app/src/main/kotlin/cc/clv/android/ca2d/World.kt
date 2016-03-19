package cc.clv.android.ca2d

import java.util.*

class World(width: Int, height: Int, rule: Rule) {
    val width = width
    val height = height
    var rule = rule
        set(value) {
            shuffle()
        }
    var cells = ByteArray(width * height)
    var running = false
        private set

    init {
        shuffle()
    }

    fun shuffle() {
        val random = Random()
        val rate = 0.1

        for (i in 0..(width * height - 1)) {
            val condMax = (rule.conditions - 1).toByte()
            cells[i] = if (random.nextDouble() < rate) condMax else 0
        }
    }

    fun tick() {
        var nextCells = ByteArray(width * height)
        val condMax = (rule.conditions - 1).toByte()

        fun index(x: Int, y: Int): Int {
            val adjustX = (x + width) % width
            val adjustY = (y + height) % height

            return adjustY * width + adjustX
        }

        for (y in 0..(height - 1)) {
            for (x in 0..(width - 1)) {

                var count = 0
                for (t in (y - 1)..(y + 1)) {
                    for (s in (x - 1)..(x + 1)) {
                        if (s == x && t == y) {
                            continue
                        }
                        if (cells[index(s, t)] == condMax) {
                            count++
                        }
                    }
                }

                val env = 1 shl count
                val idx = index(x, y)
                val prevCond = cells[idx]

                if (prevCond == 0.toByte() && (rule.born and env) > 0) {
                    nextCells[idx] = condMax
                } else if (prevCond == condMax && (rule.survive and env) > 0) {
                    nextCells[idx] = condMax
                } else {
                    if (prevCond > 0) {
                        nextCells[idx] = (prevCond - 1).toByte()
                    }
                }
            }
        }
        cells = nextCells
    }

    fun toggleRunning() {
        running = !running
    }
}
