struct CardResponse: Codable {
    let data: [Card]
}

struct Card: Codable {
    let id: String
    let name: String
    let images: Images
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let weaknesses: [Weakness]?
}

struct Images: Codable {
    let small: String
    let large: String
}

struct Weakness: Codable {
    let type: String
    let value: String
}
