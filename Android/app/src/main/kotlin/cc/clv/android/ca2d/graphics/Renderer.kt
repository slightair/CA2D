package cc.clv.android.ca2d.graphics

import android.content.Context
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import cc.clv.android.ca2d.Rule
import cc.clv.android.ca2d.World
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class Renderer(context: Context) : GLSurfaceView.Renderer {
    private val context = context
    var world: World? = null
        set(value) {
            field = value
            worldModel = if (value != null) WorldModel(value) else null
        }
    private var worldModel: WorldModel? = null
    lateinit private var shaderProgram: ShaderProgram
    private var vertexPosition = -1
    private var vertexColor = -1
    lateinit private var positionBuffer: FloatBuffer
    lateinit private var colorBuffer: FloatBuffer

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)

        GLES20.glUseProgram(shaderProgram.programId)

        renderWorld()
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)

        val cellSize = 32
        world = World(width / cellSize, height / cellSize, Rule.starwars)

        if (worldModel != null) {
            positionBuffer = ByteBuffer.allocateDirect(worldModel!!.maxVertexCount * VertexAttribSet.PositionSize)
                    .order(ByteOrder.nativeOrder()).asFloatBuffer()

            colorBuffer = ByteBuffer.allocateDirect(worldModel!!.maxVertexCount * VertexAttribSet.ColorSize)
                    .order(ByteOrder.nativeOrder()).asFloatBuffer()
        }
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
        if (worldModel == null) {
            return
        }

        val vertexAttribSet = worldModel!!.vertexAttribSet()

        positionBuffer.clear()
        positionBuffer.put(vertexAttribSet.positionArray).position(0)

        colorBuffer.clear()
        colorBuffer.put(vertexAttribSet.colorArray).position(0)

        GLES20.glVertexAttribPointer(vertexPosition, 2, GLES20.GL_FLOAT, false, 0, positionBuffer)
        GLES20.glVertexAttribPointer(vertexColor, 3, GLES20.GL_FLOAT, false, 0, colorBuffer)

        GLES20.glDrawArrays(GLES20.GL_TRIANGLES, 0, vertexAttribSet.vertexCount)
    }
}
