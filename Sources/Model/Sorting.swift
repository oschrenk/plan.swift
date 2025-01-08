import ArgumentParser
import Foundation

final class Order: ArgumentParser.ExpressibleByArgument {
  let field: String
  let direction: Direction

  public init?(argument: String) {
    let o = Order.parse(s: argument.lowercased())
    if o != nil {
      field = o!.field
      direction = o!.direction
    } else {
      return nil
    }
  }

  init(field: String, direction: Direction) {
    self.field = field
    self.direction = direction
  }

  static func parse(s: String) -> Order? {
    let ss: [String] = s.split(separator: ":").map { String($0) }
    switch ss.count {
    // found a string candidate for field only
    case 1:
      return parseField(s: ss[0]).map {
        Order(field: $0, direction: Direction.asc)
      }
    // found a string candidates for field and direction
    case 2:
      switch (parseField(s: ss[0]), Direction(rawValue: ss[1])) {
      case let (.some(f), .some(d)):
        return Order(field: f, direction: d)
      default:
        return nil
      }
    // 0 or 3+ fields is a parsing error
    default: return nil
    }
  }

  private static let event =
    Event(
      id: UUID().uuidString,
      calendar: PlanCalendar.Unknown,
      title: Title(text: "empty"),
      schedule: Schedule(
        now: Date(),
        startDate: Date(),
        endDate: Date(),
        allDay: false
      ),
      location: "",
      meeting: Meeting(organizer: "", attendees: []),
      services: [:],
      tags: []
    )

  private static func parseField(s: String) -> String? {
    do {
      try Object.valueForKeyPath(event, s)
      return s
    } catch {
      return nil
    }
  }
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
