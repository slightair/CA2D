package cc.clv.android.ca2d

import android.content.Context
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class WorldRenderer(context: Context) : GLSurfaceView.Renderer {
    private val context = context
    private var shaderProgram: ShaderProgram? = null
    private val vertexes = floatArrayOf(
            -1.0f, 1.0f, 0.0f,
            -1.0f, -1.0f, 0.0f,
            1.0f, 1.0f, 0.0f,
            1.0f, -1.0f, 0.0f
    )
    private var vertexPosition = 0
    private var vertexBuffer: FloatBuffer? = null
    private var uniformResolution = 0
    private var uniformBlockSize = 0

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)

        GLES20.glVertexAttribPointer(vertexPosition, 3, GLES20.GL_FLOAT, false, 0, vertexBuffer)
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4)
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
        GLES20.glUniform2fv(uniformResolution, 1, floatArrayOf(width.toFloat(), height.toFloat()), 0)
        GLES20.glUniform2fv(uniformBlockSize, 1, floatArrayOf(width.toFloat() / 8, height.toFloat() / 8), 0)
    }

    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        shaderProgram = ShaderProgram(context, "shader")

        val programId = shaderProgram!!.programId
        check(programId != 0)
        GLES20.glUseProgram(programId)

        vertexPosition = GLES20.glGetAttribLocation(programId, "position")
        check(vertexPosition != -1)
        GLES20.glEnableVertexAttribArray(vertexPosition)

        vertexBuffer = ByteBuffer.allocateDirect(vertexes.size * 4).order(ByteOrder.nativeOrder()).asFloatBuffer()
        vertexBuffer!!.put(vertexes).position(0)

        uniformResolution = GLES20.glGetUniformLocation(programId, "resolution")
        uniformBlockSize = GLES20.glGetUniformLocation(programId, "blockSize")
    }
}
