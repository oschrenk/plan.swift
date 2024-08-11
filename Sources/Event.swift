import EventKit
import Foundation

struct Event: Codable {
  // An event has (at least) three different identifiers
  // 1. calendarItemIdentifier (via EKCalendarItem)
  // 2. calendarItemExternalIdentifier (via EKCalendarItem)
  // 3. eventIdentifier (via EKEvent)

  // My current understanding is, to use
  // 1) to interact with the Calendar.app eg. show event
  // 2) to interact with external systems
  // 3) to retrieve items from the underlying local event store

  // re 1)
  // > is set when the calendar item is created and can be used as a local identifier
  // see also https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507075-calendaritemidentifier

  // re 2) calendarItemExternalIdentifier]
  // > identifier as provided by the calendar server.
  // > allows you to access the same event or reminder across multiple devices
  // see also https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507283-calendaritemexternalidentifier

  // re 3)
  // use this identifier to look up an event with the EKEventStore method event(withIdentifier:)
  // see also https://developer.apple.com/documentation/eventkit/ekevent/1507437-eventidentifier

  // for now we pick `calendarItemIdentifier`,
  // as the app is mostly interested in interacting with the Calendar.app
  let id: String
  let calendar: Cal
  let label: String
  let legend: Legend
  let startsAt: Date
  let startsIn: Int
  let endsAt: Date
  let endsIn: Int
  let tags: [String]

  enum CodingKeys: String, CodingKey {
    case id
    case calendar
    case label
    case legend
    case startsAt = "starts_at"
    case endsAt = "ends_at"
    case startsIn = "starts_in"
    case endsIn = "ends_in"
    case tags
  }
}

extension String {
  func findTags() -> [String] {
    let text = self

    var tags = [String]()
    var startIndex = text.startIndex
    let endIndex = text.endIndex
    while let range = text.range(
      of: "(\\w+):(\\w+)",
      options: .regularExpression,
      range: startIndex ..< endIndex
    ) {
      let kv = String(text[range]).split(separator: ":")
      let key = String(kv[0])
      if key == "tag" {
        let value = String(kv[1])
        tags.append(value)
      }

      startIndex = range.upperBound
    }

    return tags
  }
}

extension EKEvent {
  func asEvent() -> Event {
    let id = calendarItemIdentifier

    // TODO: when can this be nil???
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
    let tags = notes != nil ? notes!.findTags() : [String]()

    return Event(
      id: id,
      calendar: cal,
      label: label,
      legend: legend,
      startsAt: startsAt,
      startsIn: startsIn,
      endsAt: endsAt,
      endsIn: endsIn,
      tags: tags
    )
  }
}

extension [Event] {
  func printAsJson() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    encoder.outputFormatting = [.withoutEscapingSlashes, .prettyPrinted]
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
