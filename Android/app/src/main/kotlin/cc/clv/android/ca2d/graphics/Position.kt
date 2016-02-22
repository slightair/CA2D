package cc.clv.android.ca2d.graphics

data class Position(val x: Float, val y: Float) {
    companion object {
        val size = 4 * 2
    }

    val v: FloatArray get() = floatArrayOf(x, y)
}
