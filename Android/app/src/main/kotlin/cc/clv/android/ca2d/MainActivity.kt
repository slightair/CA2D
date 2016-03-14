package cc.clv.android.ca2d

import android.opengl.GLSurfaceView
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import cc.clv.android.ca2d.graphics.Renderer
import kotlin.concurrent.timer

class MainActivity : AppCompatActivity() {
    lateinit private var worldView: GLSurfaceView
    lateinit private var renderer: Renderer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        worldView = findViewById(R.id.fullscreen_content) as GLSurfaceView
        worldView.setEGLContextClientVersion(2)

        renderer = Renderer(applicationContext)
        worldView.setRenderer(renderer)
        worldView.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY
    }

    override fun onPostCreate(savedInstanceState: Bundle?) {
        super.onPostCreate(savedInstanceState)

        timer(period = 1000 / 30) {
            renderer.world?.tick()
        }
    }
}
