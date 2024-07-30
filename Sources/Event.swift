import EventKit
import Foundation

struct Event: Codable {
  let id: String
  let calendar: Cal
  let label: String
  let legend: Legend
  let startsAt: Date
  let startsIn: Int
  let endsAt: Date
  let endsIn: Int

  enum CodingKeys: String, CodingKey {
    case id
    case calendar
    case label
    case legend
    case startsAt = "starts_at"
    case endsAt = "ends_at"
    case startsIn = "starts_in"
    case endsIn = "ends_in"
  }
}

extension EKEvent {
  func asEvent() -> Event {
    // TODO: this can be nil???
    let id = eventIdentifier ?? "unknown"
    // TODO: this can be nil???
    let cal = if calendar != nil {
      Cal(
        id: calendar.calendarIdentifier,
        label: calendar.title
      )
    } else {
      Cal(
        id: "unknown",
        label: "unknown"
      )
    }
    let now = Date()

    let label = title ?? "unknown"
    let legend = label.asLegend()
    let startsAt = startDate!
    let endsAt = endDate!
    let startsIn = Int((startsAt.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)
    let endsIn = Int((endsAt.timeIntervalSince1970 - now.timeIntervalSince1970) / 60)

    return Event(
      id: id,
      calendar: cal,
      label: label,
      legend: legend,
      startsAt: startsAt,
      startsIn: startsIn,
      endsAt: endsAt,
      endsIn: endsIn
    )
  }
}

extension [Event] {
  func printAsJson() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    encoder.outputFormatting = .prettyPrinted
    do {
      let json = try String(
        decoding: encoder.encode(self),
        as: UTF8.self
      )
      print(json)
    } catch {
      print("fail")
    }
  }
}
