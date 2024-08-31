import EventKit
import Foundation

struct Event: Codable {
  // An EKEvent has three different identifiers
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
  //
  // re 3)
  // use this identifier to look up an event with the EKEventStore method event(withIdentifier:)
  // see also https://developer.apple.com/documentation/eventkit/ekevent/1507437-eventidentifier
  //
  // for now we pick `calendarItemIdentifier`,
  // as the app is mostly interested in interacting with the Calendar.app
  let id: String
  let calendar: Calendar
  let title: Title
  let schedule: Schedule
  let location: String
  let services: [String: String]
  let tags: [String]

  enum CodingKeys: String, CodingKey {
    case id
    case calendar
    case title
    case schedule
    case location
    case services
    case tags
  }
}

extension String {
  func findTags() -> [String] {
    let text = self
    let separator = ":"
    let tag = "tag"

    var tags = [String]()
    var startIndex = text.startIndex
    let endIndex = text.endIndex
    while let range = text.range(
      of: "(\\w+):(\\w+)",
      options: .regularExpression,
      range: startIndex ..< endIndex
    ) {
      let keyValue = String(text[range]).split(separator: separator)
      let key = String(keyValue[0])
      if key == tag {
        let value = String(keyValue[1])
        tags.append(value)
      }

      startIndex = range.upperBound
    }

    return tags
  }
}

extension EKEvent {
  // convenience method to build services urls from EKEvent
  func listServices() -> [String: String] {
    Service.fromEvent(
      notes: notes ?? "",
      calendarItemIdentifier: calendarItemIdentifier,
      isAllDay: isAllDay,
      hasRecurrenceRules: hasRecurrenceRules,
      startDate: startDate
    )
  }

  func asEvent() -> Event {
    let id = calendarItemIdentifier
    let cal = calendar?.asCal() ?? Calendar.Unknown
    let title = Title(text: title ?? "unknown")
    let schedule = Schedule(
      now: Date(),
      startDate: startDate!,
      endDate: endDate!
    )
    let location = location ?? ""
    let services = listServices()
    let tags = notes?.findTags() ?? []

    return Event(
      id: id,
      calendar: cal,
      title: title,
      schedule: schedule,
      location: location,
      services: services,
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
      StdOut.print(json)
    } catch {
      StdErr.print("fail")
    }
  }
}
