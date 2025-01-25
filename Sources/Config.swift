struct Config: Codable {
  let iconize: [Rule]?
}

struct Rule: Codable {
  let field: String
  let regex: String
  let icon: String
}
