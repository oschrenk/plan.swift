import Foundation

struct Temporal: Codable, ReverseCodable, Equatable {
  let at: Date
  let inMinutes: Int

  enum CodingKeys: String, CodingKey {
    case at
    case inMinutes = "in"
  }

  static func == (lhs: Temporal, rhs: Temporal) -> Bool {
    return
      lhs.at == rhs.at &&
      lhs.inMinutes == rhs.inMinutes
  }

  static func reverseCodingKeys() -> [String: String] {
    return [
      CodingKeys.at.rawValue: "at",
      CodingKeys.inMinutes.rawValue: "inMinutes",
    ]
  }
}
