package cc.clv.android.ca2d.graphics

data class VertexAttribSet(val vertexCount: Int, val positionArray: FloatArray, val colorArray: FloatArray) {
    companion object {
        val PositionSize = 4 * 2
        val ColorSize = 4 * 3
    }
}
