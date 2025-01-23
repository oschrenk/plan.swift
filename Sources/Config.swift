struct Config: Codable {
  let iconize: [Rule]?
  let watcher: Watcher?
}

struct Rule: Codable {
  let field: String
  let regex: String
  let icon: String
}

struct Watcher: Codable {
  let hook: Hook?
}

struct Hook: Codable {
  let path: String
  let args: [String]
}
