import Foundation

struct Schedule: Codable, ReverseCodable, Equatable {
  let start: Temporal
  let end: Temporal
  let allDay: Bool

  init(now: Date, startDate: Date, endDate: Date, allDay isAllDay: Bool) {
    start = Temporal(
      at: startDate,
      inMinutes: Int((startDate.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)
    )
    end = Temporal(
      at: endDate,
      inMinutes: Int((endDate.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)
    )
    allDay = isAllDay
  }

  static func == (lhs: Schedule, rhs: Schedule) -> Bool {
    return
      lhs.start == rhs.start &&
      lhs.end == rhs.end &&
      lhs.allDay == rhs.allDay
  }

  enum CodingKeys: String, CodingKey, CaseIterable {
    case start
    case end
    case allDay = "all_day"
  }

  static func reverseCodingKeys() -> [String: String] {
    return [
      CodingKeys.start.rawValue: "start",
      CodingKeys.end.rawValue: "end",
      CodingKeys.allDay.rawValue: "allDay",
    ]
  }
}
