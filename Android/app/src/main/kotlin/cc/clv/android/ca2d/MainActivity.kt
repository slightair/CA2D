package cc.clv.android.ca2d

import android.opengl.GLSurfaceView
import android.os.Bundle
import android.support.v4.widget.DrawerLayout
import android.support.v7.app.ActionBarDrawerToggle
import android.support.v7.app.AppCompatActivity
import android.view.MenuItem
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import cc.clv.android.ca2d.graphics.Renderer

class MainActivity : AppCompatActivity() {
    lateinit private var drawerLayout: DrawerLayout
    lateinit private var drawerList: ListView
    lateinit private var headerView: View
    lateinit private var drawerToggle: ActionBarDrawerToggle
    lateinit private var worldView: GLSurfaceView
    lateinit private var renderer: Renderer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        drawerLayout = findViewById(R.id.drawer_layout) as DrawerLayout
        drawerList = findViewById(R.id.left_drawer) as ListView

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setHomeButtonEnabled(true)
        drawerToggle = ActionBarDrawerToggle(this, drawerLayout, R.string.navigation_drawer_open, R.string.navigation_drawer_close)
        drawerLayout.addDrawerListener(drawerToggle)
        drawerToggle.syncState()

        headerView = layoutInflater.inflate(R.layout.drawer_header, null) as View

        drawerList.addHeaderView(headerView)
        drawerList.adapter = ArrayAdapter<String>(this, R.layout.drawer_list_item, Rule.presets.map { it.name })

        worldView = findViewById(R.id.fullscreen_content) as GLSurfaceView
        worldView.setEGLContextClientVersion(2)

        renderer = Renderer(applicationContext)
        worldView.setRenderer(renderer)
        worldView.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        if (drawerToggle.onOptionsItemSelected(item)) {
            return true
        }
        return super.onOptionsItemSelected(item)
    }
}
