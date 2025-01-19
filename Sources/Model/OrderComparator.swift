import Foundation

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
        return IntComparator(order: order).compare(leftValue, rightValue)
      } else if let leftValue = leftV as? String, let rightValue = rightV as? String {
        return StringComparator(order: order).compare(leftValue, rightValue)
      } else if let leftValue = leftV as? Date, let rightValue = rightV as? Date {
        return DateComparator(order: order).compare(leftValue, rightValue)
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

class IntComparator: SortComparator, Hashable {
  var order: SortOrder

  init(order: SortOrder) {
    self.order = order
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(order)
  }

  static func == (lhs: IntComparator, rhs: IntComparator) -> Bool {
    return lhs.order == rhs.order
  }

  func compare(_ lhs: Int, _ rhs: Int) -> ComparisonResult {
    let result: ComparisonResult
    if lhs < rhs {
      result = .orderedAscending
    } else if lhs > rhs {
      result = .orderedDescending
    } else {
      result = .orderedSame
    }
    return order == .forward ? result : result.reversed
  }
}

class StringComparator: SortComparator, Hashable {
  var order: SortOrder

  init(order: SortOrder) {
    self.order = order
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(order)
  }

  static func == (lhs: StringComparator, rhs: StringComparator) -> Bool {
    return lhs.order == rhs.order
  }

  func compare(_ lhs: String, _ rhs: String) -> ComparisonResult {
    let result: ComparisonResult
    if lhs < rhs {
      result = .orderedAscending
    } else if lhs > rhs {
      result = .orderedDescending
    } else {
      result = .orderedSame
    }
    return order == .forward ? result : result.reversed
  }
}

class DateComparator: SortComparator, Hashable {
  var order: SortOrder

  init(order: SortOrder) {
    self.order = order
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(order)
  }

  static func == (lhs: DateComparator, rhs: DateComparator) -> Bool {
    return lhs.order == rhs.order
  }

  func compare(_ lhs: Date, _ rhs: Date) -> ComparisonResult {
    let result: ComparisonResult
    if lhs < rhs {
      result = .orderedAscending
    } else if lhs > rhs {
      result = .orderedDescending
    } else {
      result = .orderedSame
    }
    return order == .forward ? result : result.reversed
  }
}

extension ComparisonResult {
  var reversed: ComparisonResult {
    switch self {
    case .orderedAscending: return .orderedDescending
    case .orderedSame: return .orderedSame
    case .orderedDescending: return .orderedAscending
    }
  }
}
