enum Object {
  enum PathError: Error {
    case notComparable
    case notDecodable
    case notFound
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
        throw PathError.notFound
      }
    }

    guard let comparableObject = currentObject as? any Comparable else {
      throw PathError.notComparable
    }

    return comparableObject
  }

  static func originalPropertyName(for wanted: String, in object: Any) throws -> String? {
    guard let reverseCodable = object as? ReverseCodable else {
      throw PathError.notDecodable
    }

    let candidates = type(of: reverseCodable).reverseCodingKeys()

    for case let (coded, original) in candidates where coded == wanted {
      return original
    }

    throw PathError.notFound
  }
}
