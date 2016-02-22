package cc.clv.android.ca2d.graphics

data class Color(val r: Float, val g: Float, val b: Float) {
    companion object {
        val size = 4 * 3
    }

    val v: FloatArray get() = floatArrayOf(r, g, b)
}
