import Foundation

struct Temporal: Codable, ReverseCodable {
  let at: Date
  let inMinutes: Int

  enum CodingKeys: String, CodingKey {
    case at
    case inMinutes = "in"
  }

  static func reverseCodingKeys() -> [String: String] {
    return [
      CodingKeys.at.rawValue: "at",
      CodingKeys.inMinutes.rawValue: "inMinutes",
    ]
  }
}
