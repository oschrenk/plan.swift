import Foundation

struct Temporal: Codable, ReverseCodable, Equatable {
  let at: Date
  let inMinutes: Int

  enum CodingKeys: String, CodingKey {
    case at
    case inMinutes = "in"
  }

  static func reverseCodingKeys() -> [String: String] {
    [
      CodingKeys.at.rawValue: "at",
      CodingKeys.inMinutes.rawValue: "inMinutes",
    ]
  }
}
