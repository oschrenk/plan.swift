import Foundation

struct Temporal: Codable {
  let at: Date
  let inMinutes: Int

  enum CodingKeys: String, CodingKey {
    case at
    case inMinutes = "in"
  }
}
