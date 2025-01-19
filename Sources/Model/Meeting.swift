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
    return [
      CodingKeys.organizer.rawValue: "organizer",
      CodingKeys.attendees.rawValue: "attendees",
    ]
  }

  static func == (lhs: Meeting, rhs: Meeting) -> Bool {
    return
      lhs.organizer == rhs.organizer &&
      lhs.attendees == rhs.attendees
  }
}

extension [EKParticipant] {
  func asString() -> [String] {
    return self.map { $0.name ?? $0.url.absoluteString }
  }
}
