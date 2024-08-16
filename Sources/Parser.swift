import Foundation

class Parser {
  static func parse(text: String) -> AddEvent {
    AddEvent(
      title: text,
      startsAt: Date(),
      endsAt: Date(),
      notes: "Some notes"
    )
  }
}
