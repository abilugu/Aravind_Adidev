struct Address: Decodable {
    let id: String
    let name: String
}

struct Letter: Decodable {
    let from: Address
    let to: Address
    let areFriends: Bool
    let timestamp: String
}
