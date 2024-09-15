import Foundation

struct Temporal: Codable, KeyPathAccessible {
  let at: Date
  let inMinutes: Int

  enum CodingKeys: String, CodingKey {
    case at
    case inMinutes = "in"
  }

  static func codingKey(for key: String) -> CodingKey? {
    return CodingKeys(stringValue: key)
  }
}
