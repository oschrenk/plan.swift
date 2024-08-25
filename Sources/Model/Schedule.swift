import Foundation

struct Schedule: Codable {
  let start: Temporal
  let end: Temporal

  init(now: Date, startDate: Date, endDate: Date) {
    start = Temporal(
      at: startDate,
      inMinutes: Int((startDate.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)
    )
    end = Temporal(
      at: endDate,
      inMinutes: Int((endDate.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)
    )
  }
}
