import EventKit
import Foundation

struct Meeting: Codable, KeyPathAccessible {
  let organizer: String
  let attendees: [String]

  enum CodingKeys: String, CodingKey {
    case organizer
    case attendees
  }

  static func codingKey(for key: String) -> CodingKey? {
    return CodingKeys(stringValue: key)
  }
}

extension [EKParticipant] {
  func asString() -> [String] {
    return self.map { $0.name ?? $0.url.absoluteString }
  }
}
