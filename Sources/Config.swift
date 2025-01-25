struct Config: Codable {
  let iconize: [Rule]?
  let hooks: [Hook]?
}

struct Rule: Codable {
  let field: String
  let regex: String
  let icon: String
}

struct Hook: Codable {
  let path: String
  let args: [String]?
}
