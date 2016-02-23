package cc.clv.android.ca2d

import org.junit.Assert.assertEquals
import org.junit.Test

class RuleTest {

    @Test
    @Throws(Exception::class)
    fun createRule() {
        val banners = Rule("Banners", "2367/3457/5")
        assertEquals("Banners", banners.name)
        assertEquals(204, banners.survive)
        assertEquals(184, banners.born)
        assertEquals(5, banners.conditions)

        val brain = Rule("Brian's Brain", "/2/3")
        assertEquals("Brian's Brain", brain.name)
        assertEquals(0, brain.survive)
        assertEquals(4, brain.born)
        assertEquals(3, brain.conditions)

        val chenille = Rule("Chenille", "05678/24567/6")
        assertEquals("Chenille", chenille.name)
        assertEquals(481, chenille.survive)
        assertEquals(244, chenille.born)
        assertEquals(6, chenille.conditions)

        val starWars = Rule("Star Wars", "345/2/4")
        assertEquals("Star Wars", starWars.name)
        assertEquals(56, starWars.survive)
        assertEquals(4, starWars.born)
        assertEquals(4, starWars.conditions)
    }
}
