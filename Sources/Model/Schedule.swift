import Foundation

struct Schedule: Codable, KeyPathAccessible {
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

  enum CodingKeys: String, CodingKey {
    case start
    case end
    case allDay = "all_day"
  }

  static func codingKey(for key: String) -> CodingKey? {
    return CodingKeys(stringValue: key)
  }
}
