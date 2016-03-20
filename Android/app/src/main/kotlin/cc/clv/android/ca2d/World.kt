package cc.clv.android.ca2d

import java.util.*
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

class World(width: Int, height: Int, rule: Rule) {
    val width = width
    val height = height
    var rule = rule
        set(value) {
            lock.withLock {
                field = value
                running = false
                shuffle()
            }
        }
    var cells = ByteArray(width * height)
    var running = false
        private set
    val lock = ReentrantLock()

    init {
        shuffle()
    }

    fun shuffle() {
        lock.withLock {
            val random = Random()
            val rate = 0.1

            var newCells = ByteArray(width * height)
            for (i in 0..(width * height - 1)) {
                val condMax = (rule.conditions - 1).toByte()
                newCells[i] = if (random.nextDouble() < rate) condMax else 0
            }
            cells = newCells
        }
    }

    fun tick() {
        lock.withLock {
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
    }

    fun toggleRunning() {
        running = !running
    }
}
