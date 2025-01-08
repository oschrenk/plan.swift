import ArgumentParser
import Foundation

class Sorting {
  let field: Field
  let direction: Direction

  init(field: Field, direction: Direction) {
    self.field = field
    self.direction = direction
  }

  func sort(events: [Event]) -> [Event] {
    if field == .start {
      if direction == .asc {
      } else {}
    }
    return events
  }

  static func parse(s: String) -> Sorting? {
    let ss: [String] = s.split(separator: ":").map { String($0) }
    switch ss.count {
    // found a string candidate for field only
    case 1:
      return parseField(ss[0]).map {
        Sorting(field: $0, direction: Direction.asc)
      }
    // found a string candidates for field and direction
    case 2:
      switch (parseField(ss[0]), Direction(rawValue: ss[1])) {
      case let (.some(f), .some(d)):
        return Sorting(field: f, direction: d)
      default:
        return nil
      }
    // 0 or 3+ fields is a parsing error
    default: return nil
    }
  }

  private static func parseField(_: String) -> Field? {
    nil
  }
}

enum Field: String, ExpressibleByArgument {
  case start
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
