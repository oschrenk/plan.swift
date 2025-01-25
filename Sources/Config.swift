import Foundation

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

  func trigger() {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: path)
    task.arguments = args ?? []
    do {
      try task.run()
      task.waitUntilExit()
      print("Fired event \(path) with args \(args ?? [])")
    } catch {
      print("Failed to execute command \(path): \(error)")
    }
  }
}
