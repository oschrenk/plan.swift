import EventKit
import Foundation

struct Meeting: Codable {
  let organizer: String
  let attendees: [String]

  enum CodingKeys: String, CodingKey {
    case organizer
    case attendees
  }
}

extension [EKParticipant] {
  func asString() -> [String] {
    return self.map { $0.name ?? $0.url.absoluteString }
  }
}
