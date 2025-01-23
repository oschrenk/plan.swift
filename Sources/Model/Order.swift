import ArgumentParser
import Foundation

final class Order: ArgumentParser.ExpressibleByArgument, Hashable {
  let field: String
  let direction: Direction

  public init?(argument: String) {
    let obj = Order.parse(s: argument.lowercased())
    if obj != nil {
      field = obj!.field
      direction = obj!.direction
    } else {
      return nil
    }
  }

  init(field: String, direction: Direction) {
    self.field = field
    self.direction = direction
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(field)
    hasher.combine(direction)
  }

  static let Default: Order = .parse(s: "schedule.start.in:asc")!

  static func == (lhs: Order, rhs: Order) -> Bool {
    return lhs.field == rhs.field && lhs.direction == rhs.direction
  }

  static func parse(s: String) -> Order? {
    let rawOrder: [String] = s.split(separator: ":").map { String($0) }
    switch rawOrder.count {
    // found a string candidate for field only
    case 1:
      return parseField(s: rawOrder[0]).map {
        Order(field: $0, direction: Direction.asc)
      }
    // found a string candidates for field and direction
    case 2:
      switch (parseField(s: rawOrder[0]), Direction(rawValue: rawOrder[1])) {
      case let (.some(field), .some(direction)):
        return Order(field: field, direction: direction)
      default:
        return nil
      }
    // 0 or 3+ fields is a parsing error
    default: return nil
    }
  }

  private static func parseField(s: String) -> String? {
    do {
      try Object.valueForKeyPath(Event.Empty, s)
      return s
    } catch {
      return nil
    }
  }
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
