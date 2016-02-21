package cc.clv.android.ca2d.graphics


data class Vertex(val position: Position, val color: Color) {
    companion object {
        val size = Position.size + Color.size
    }

    val v: FloatArray
        get() = floatArrayOf(
                position.x,
                position.y,
                color.r,
                color.g,
                color.b
        )
}
