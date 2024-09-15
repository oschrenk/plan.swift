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

  static func valueForKeyPath(_ object: Any, _ keyPath: String) -> Any? {
    let keys = keyPath.split(separator: ".").map { String($0) }
    var currentObject: Any = object

    for key in keys {
      let mirror = Mirror(reflecting: currentObject)

      // Try to find the property in the current object
      if let child = mirror.children.first(where: { $0.label == key }) {
        currentObject = child.value
      } else {
        return nil // Key not found
      }
    }

    return currentObject
  }
}

enum Field: String, ExpressibleByArgument {
  case start
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
