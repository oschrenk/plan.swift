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

class OrderComparator: SortComparator {
  let field: String
  var order: SortOrder

  init(order: Order) {
    field = order.field
    if order.direction == Direction.asc {
      self.order = SortOrder.forward
    } else {
      self.order = SortOrder.reverse
    }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(field)
    hasher.combine(order)
  }

  static func == (lhs: OrderComparator, rhs: OrderComparator) -> Bool {
    return lhs.field == rhs.field
  }

  func compare(_ lhs: Event, _ rhs: Event) -> ComparisonResult {
    let maybeLeftV = try? Object.valueForKeyPath(lhs, field)
    let maybeRightV = try? Object.valueForKeyPath(rhs, field)

    switch (maybeLeftV, maybeRightV) {
    case let (.some(leftV), .some(rightV)):
      if let leftValue = leftV as? Int, let rightValue = rightV as? Int {
        if leftValue < rightValue {
          return .orderedAscending
        } else if leftValue > rightValue {
          return .orderedDescending
        } else {
          return .orderedSame
        }
      } else if let leftValue = leftV as? String, let rightValue = rightV as? String {
        if leftValue < rightValue {
          return .orderedAscending
        } else if leftValue > rightValue {
          return .orderedDescending
        } else {
          return .orderedSame
        }
      } else if let leftValue = leftV as? Date, let rightValue = rightV as? Date {
        if leftValue < rightValue {
          return .orderedAscending
        } else if leftValue > rightValue {
          return .orderedDescending
        } else {
          return .orderedSame
        }
      } else {
        // not future proof
        // we might silently sort on new non-existing types
        return .orderedSame
      }
    default:
      // not future proof
      // we might silently sort on new non-existing types
      return .orderedSame
    }
  }
}
