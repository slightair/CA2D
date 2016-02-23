package cc.clv.android.ca2d

data class Rule(val name: String, val rule: String) {
    companion object {
        val presets = arrayOf(
                Rule("Banners", "2367/3457/5"),
                Rule("BelZhab", "23/23/8"),
                Rule("BelZhab Sediment", "145678/23/8"),
                Rule("Bloomerang", "234/34678/24"),
                Rule("Bombers", "345/24/25"),
                Rule("Brain 6", "6/246/3"),
                Rule("Brian's Brain", "/2/3"),
                Rule("Burst", "0235678/3468/9"),
                Rule("BurstII", "235678/3468/9"),
                Rule("Caterpillars", "124567/378/4"),
                Rule("Chenille", "05678/24567/6"),
                Rule("Circuit Genesis", "2345/1234/8"),
                Rule("Cooties", "23/2/8"),
                Rule("Ebb&Flow", "012478/36/18"),
                Rule("Ebb&Flow II", "012468/37/18"),
                Rule("Faders", "2/2/25"),
                Rule("Fireworks", "2/13/21"),
                Rule("Flaming Starbows", "347/23/8"),
                Rule("Frogs", "12/34/3"),
                Rule("Frozen spirals", "356/23/6"),
                Rule("Glisserati", "035678/245678/7"),
                Rule("Glissergy", "035678/245678/5"),
                Rule("Lava", "12345/45678/8"),
                Rule("Life", "23/3/2"),
                Rule("Lines", "012345/458/3"),
                Rule("LivingOn TheEdge", "345/3/6"),
                Rule("Meteor Guns", "01245678/3/8"),
                Rule("Nova", "45678/2478/25"),
                Rule("OrthoGo", "3/2/4"),
                Rule("Prairie on fire", "345/34/6"),
                Rule("RainZha", "2/23/8"),
                Rule("Rake", "3467/2678/6"),
                Rule("SediMental", "45678/25678/4"),
                Rule("Snake", "03467/25/6"),
                Rule("SoftFreeze", "13458/38/6"),
                Rule("Spirals", "2/234/5"),
                Rule("Star Wars", "345/2/4"),
                Rule("Sticks", "3456/2/6"),
                Rule("Swirl", "23/34/8"),
                Rule("ThrillGrill", "1234/34/48"),
                Rule("Transers", "345/26/5"),
                Rule("TransersII", "0345/26/6"),
                Rule("Wanderers", "345/34678/5"),
                Rule("Worms", "3467/25/6"),
                Rule("Xtasy", "1456/2356/16")
        )
    }

    val survive: Int
    val born: Int
    val conditions: Int

    init {
        val components = rule.split("/")
        check(components.count() == 3, { "Unexpected rule string" })

        val combine = { result: Int, char: Char -> result + (1.shl(char.toString().toInt())) }
        survive = components[0].fold(0, combine)
        born = components[1].fold(0, combine)
        conditions = components[2].toInt()
    }
}
