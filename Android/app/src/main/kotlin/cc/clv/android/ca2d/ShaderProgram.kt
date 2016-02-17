package cc.clv.android.ca2d

import android.content.Context
import android.opengl.GLES20
import android.util.Log

class ShaderProgram(context: Context, shaderName: String) {
    companion object {
        val TAG = "ShaderProgram"
    }

    val context = context
    var programId: Int = 0

    init {
        programId = GLES20.glCreateProgram()
        if (programId != 0) {
            loadShaders(shaderName)
        }
    }

    fun loadShaders(shaderName: String) {
        val assets = context.resources.assets

        val vertexShaderSource = assets.open("shader/${shaderName}.vsh").reader().use { it.readText() }
        val fragmentShaderSource = assets.open("shader/${shaderName}.fsh").reader().use { it.readText() }

        val vertexShader = compileShader(GLES20.GL_VERTEX_SHADER, vertexShaderSource)
        if (vertexShader == 0) {
            programId = 0
            return
        }

        val fragmentShader = compileShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderSource)
        if (fragmentShader == 0) {
            programId = 0
            return
        }

        GLES20.glAttachShader(programId, vertexShader)
        GLES20.glAttachShader(programId, fragmentShader)

        GLES20.glLinkProgram(programId)

        val linkStatus = intArrayOf(0)
        GLES20.glGetProgramiv(programId, GLES20.GL_LINK_STATUS, linkStatus, 0)
        if (linkStatus.first() != GLES20.GL_TRUE) {
            Log.e(TAG, "Could not link program:")
            Log.e(TAG, GLES20.glGetProgramInfoLog(programId))

            GLES20.glDeleteShader(vertexShader)
            GLES20.glDeleteShader(fragmentShader)
            GLES20.glDeleteProgram(programId)
            programId = 0
            return
        }

        GLES20.glDetachShader(programId, vertexShader)
        GLES20.glDeleteShader(vertexShader)

        GLES20.glDetachShader(programId, fragmentShader)
        GLES20.glDeleteShader(fragmentShader)
    }

    fun compileShader(shaderType: Int, source: String): Int {
        var shader = GLES20.glCreateShader(shaderType)
        if (shader != 0) {
            GLES20.glShaderSource(shader, source)
            GLES20.glCompileShader(shader)

            val compiled = intArrayOf(0)
            GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compiled, 0)
            if (compiled.first() == 0) {
                Log.e(TAG, "Could not compile shader " + shaderType + ":")
                Log.e(TAG, GLES20.glGetShaderInfoLog(shader))
                GLES20.glDeleteShader(shader)
                shader = 0
            }
        }
        return shader
    }
}
