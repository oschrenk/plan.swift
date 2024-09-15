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
}

enum Field: String, ExpressibleByArgument {
  case start
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
