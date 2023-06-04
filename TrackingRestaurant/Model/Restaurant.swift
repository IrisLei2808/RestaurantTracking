struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let image_url: String
    let rating: Double
    let price: String?
}


struct RestaurantResponse: Decodable {
    let businesses: [Restaurant]
}

