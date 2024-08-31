import Foundation

class Sketchybar {
  private let event: String

  init(event: String) {
    self.event = event
  }

  func trigger() {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/sketchybar")
    task.arguments = ["--trigger", event]

    do {
      try task.run()
      task.waitUntilExit()
      print("Fired sketchybar event \(event)")
    } catch {
      print("Failed to execute command: \(error)")
    }
  }
}
