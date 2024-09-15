import ArgumentParser
import Foundation

enum SortingPathError: Error {
  case notDecodable
  case noKeyFound
  case noValueFound
  case notComparable
}

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

  static func originalPropertyName(for wanted: String, in object: Any) throws -> String? {
    guard let reverseCodable = object as? ReverseCodable else {
      throw SortingPathError.notDecodable
    }

    let candidates = type(of: reverseCodable).reverseCodingKeys()

    for case let (original, coded) in candidates {
      if coded == wanted {
        return original
      }
    }

    throw SortingPathError.noKeyFound
  }

  static func valueForKeyPath(_ object: Any, _ keyPath: String) throws -> Any? {
    let keys = keyPath.split(separator: ".").map { String($0) }

    var currentObject: Any = object

    for key in keys {
      let propertyName = try? originalPropertyName(for: key, in: currentObject)

      let mirror = Mirror(reflecting: currentObject)

      if let child = mirror.children.first(where: { $0.label == propertyName }) {
        currentObject = child.value
      } else {
        throw SortingPathError.noValueFound
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
