import EventKit
import Foundation

struct Meeting: Codable, ReverseCodable, Equatable {
  let organizer: String
  let attendees: [String]

  enum CodingKeys: String, CodingKey, CaseIterable {
    case organizer
    case attendees
  }

  static func reverseCodingKeys() -> [String: String] {
    [
      CodingKeys.organizer.rawValue: "organizer",
      CodingKeys.attendees.rawValue: "attendees",
    ]
  }
}

extension [EKParticipant] {
  func asString() -> [String] {
    self.map { $0.name ?? $0.url.absoluteString }
  }
}
