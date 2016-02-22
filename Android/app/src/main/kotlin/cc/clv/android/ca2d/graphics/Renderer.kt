package cc.clv.android.ca2d.graphics

import android.content.Context
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import cc.clv.android.ca2d.World
import java.nio.ByteBuffer
import java.nio.ByteOrder
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class Renderer(context: Context, world: World) : GLSurfaceView.Renderer {
    private val context = context
    private val worldModel = WorldModel(world)
    lateinit private var shaderProgram: ShaderProgram
    private var vertexPosition = -1
    private var vertexColor = -1

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)

        GLES20.glUseProgram(shaderProgram.programId)

        renderWorld()
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
    }

    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        shaderProgram = ShaderProgram(context, "shader")

        val programId = shaderProgram.programId
        check(programId != 0, { "Failed to create shader program" })

        vertexPosition = GLES20.glGetAttribLocation(programId, "position")
        check(vertexPosition != -1, { "Failed to get position attribute location" })
        GLES20.glEnableVertexAttribArray(vertexPosition)

        vertexColor = GLES20.glGetAttribLocation(programId, "color")
        check(vertexColor != -1, { "Failed to get color attribute location" })
        GLES20.glEnableVertexAttribArray(vertexColor)
    }

    private fun renderWorld() {
        val modelVertexPositions = worldModel.positions()
        val vertexPositions = modelVertexPositions.flatMap { it.v.asIterable() }

        val modelVertexColors = worldModel.colors()
        val vertexColors = modelVertexColors.flatMap { it.v.asIterable() }

        val positionBuffer = ByteBuffer.allocateDirect(modelVertexPositions.size * Position.size)
                .order(ByteOrder.nativeOrder()).asFloatBuffer()
        positionBuffer.put(vertexPositions.toFloatArray()).position(0)

        val colorBuffer = ByteBuffer.allocateDirect(modelVertexColors.size * Color.size)
                .order(ByteOrder.nativeOrder()).asFloatBuffer()
        colorBuffer.put(vertexColors.toFloatArray()).position(0)

        GLES20.glVertexAttribPointer(vertexPosition, 2, GLES20.GL_FLOAT, false, 0, positionBuffer)
        GLES20.glVertexAttribPointer(vertexColor, 3, GLES20.GL_FLOAT, false, 0, colorBuffer)

        GLES20.glDrawArrays(GLES20.GL_TRIANGLES, 0, modelVertexPositions.count())
    }
}
