import Foundation

struct Rule {
    let name: String
    let survive, born, conditions: Int

    init(name: String, rule: String) {
        self.name = name

        let components = rule.componentsSeparatedByString("/")
        guard components.count == 3 else {
            fatalError("Unexpected rule string")
        }

        let combine = {(result: Int, item: Character) -> Int in result + (1 << (Int(String(item))!))}

        self.survive = components[0].characters.reduce(0, combine: combine)
        self.born = components[1].characters.reduce(0, combine: combine)
        self.conditions = Int(components[2])!
    }

    static let presets = [
        Rule(name: "Banners", rule: "2367/3457/5"),
        Rule(name: "BelZhab", rule: "23/23/8"),
        Rule(name: "BelZhab Sediment", rule: "145678/23/8"),
        Rule(name: "Bloomerang", rule: "234/34678/24"),
        Rule(name: "Bombers", rule: "345/24/25"),
        Rule(name: "Brain 6", rule: "6/246/3"),
        Rule(name: "Brian's Brain", rule: "/2/3"),
        Rule(name: "Burst", rule: "0235678/3468/9"),
        Rule(name: "BurstII", rule: "235678/3468/9"),
        Rule(name: "Caterpillars", rule: "124567/378/4"),
        Rule(name: "Chenille", rule: "05678/24567/6"),
        Rule(name: "Circuit Genesis", rule: "2345/1234/8"),
        Rule(name: "Cooties", rule: "23/2/8"),
        Rule(name: "Ebb&Flow", rule: "012478/36/18"),
        Rule(name: "Ebb&Flow II", rule: "012468/37/18"),
        Rule(name: "Faders", rule: "2/2/25"),
        Rule(name: "Fireworks", rule: "2/13/21"),
        Rule(name: "Flaming Starbows", rule: "347/23/8"),
        Rule(name: "Frogs", rule: "12/34/3"),
        Rule(name: "Frozen spirals", rule: "356/23/6"),
        Rule(name: "Glisserati", rule: "035678/245678/7"),
        Rule(name: "Glissergy", rule: "035678/245678/5"),
        Rule(name: "Lava", rule: "12345/45678/8"),
        Rule(name: "Lines", rule: "012345/458/3"),
        Rule(name: "LivingOn TheEdge", rule: "345/3/6"),
        Rule(name: "Meteor Guns", rule: "01245678/3/8"),
        Rule(name: "Nova", rule: "45678/2478/25"),
        Rule(name: "OrthoGo", rule: "3/2/4"),
        Rule(name: "Prairie on fire", rule: "345/34/6"),
        Rule(name: "RainZha", rule: "2/23/8"),
        Rule(name: "Rake", rule: "3467/2678/6"),
        Rule(name: "SediMental", rule: "45678/25678/4"),
        Rule(name: "Snake", rule: "03467/25/6"),
        Rule(name: "SoftFreeze", rule: "13458/38/6"),
        Rule(name: "Spirals", rule: "2/234/5"),
        Rule(name: "Star Wars", rule: "345/2/4"),
        Rule(name: "Sticks", rule: "3456/2/6"),
        Rule(name: "Swirl", rule: "23/34/8"),
        Rule(name: "ThrillGrill", rule: "1234/34/48"),
        Rule(name: "Transers", rule: "345/26/5"),
        Rule(name: "TransersII", rule: "0345/26/6"),
        Rule(name: "Wanderers", rule: "345/34678/5"),
        Rule(name: "Worms", rule: "3467/25/6"),
        Rule(name: "Xtasy", rule: "1456/2356/16"),
    ]
}
