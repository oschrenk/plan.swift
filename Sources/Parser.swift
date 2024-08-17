import Foundation

class Parser {
  // - 08:00 - 10:00 🏝️ Take a break
  static func parse(text: String) -> AddEvent {
    AddEvent(
      title: text,
      startsAt: Date(),
      endsAt: Date()
    )
  }
}
