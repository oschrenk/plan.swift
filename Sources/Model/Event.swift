import EventKit
import Foundation
import swift_lens

/// An Event describes an event
///
/// It's constructed from an EKEvent
///
/// An EKEvent has three different identifiers
/// 1. calendarItemIdentifier (via EKCalendarItem)
/// 2. calendarItemExternalIdentifier (via EKCalendarItem)
/// 3. eventIdentifier (via EKEvent)

/// My current understanding is, to use
/// 1) to interact with the Calendar.app eg. show event
/// 2) to interact with external systems
/// 3) to retrieve items from the underlying local event store

/// re 1)
/// > is set when the calendar item is created and can be used as a local identifier
/// see also https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507075-calendaritemidentifier

/// re 2) calendarItemExternalIdentifier]
/// > identifier as provided by the calendar server.
/// > allows you to access the same event or reminder across multiple devices
/// see also https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507283-calendaritemexternalidentifier
///
/// re 3)
/// > use this identifier to look up an event with the EKEventStore method
/// > event(withIdentifier:)
/// see also https://developer.apple.com/documentation/eventkit/ekevent/1507437-eventidentifier
///
/// for now we pick `calendarItemIdentifier`,
/// as the app is mostly interested in interacting with the Calendar.app
struct Event: Codable, ReverseCodable, Equatable {
  let id: String
  let calendar: PlanCalendar
  let title: Title
  let schedule: Schedule
  let location: String
  let meeting: Meeting
  let services: [String: String]
  let tags: [String]

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case calendar
    case title
    case schedule
    case location
    case meeting
    case services
    case tags
  }

  static func == (lhs: Event, rhs: Event) -> Bool {
    return
      lhs.id == rhs.id &&
      lhs.calendar == rhs.calendar &&
      lhs.title == rhs.title &&
      lhs.schedule == rhs.schedule &&
      lhs.location == rhs.location &&
      lhs.meeting == rhs.meeting &&
      lhs.services == rhs.services &&
      lhs.tags == rhs.tags
  }

  static func reverseCodingKeys() -> [String: String] {
    return [
      CodingKeys.id.rawValue: "id",
      CodingKeys.calendar.rawValue: "calendar",
      CodingKeys.title.rawValue: "title",
      CodingKeys.schedule.rawValue: "schedule",
      CodingKeys.location.rawValue: "location",
      CodingKeys.meeting.rawValue: "meeting",
      CodingKeys.services.rawValue: "services",
      CodingKeys.tags.rawValue: "tags",
    ]
  }

  /// Generate an Event
  static func generate(
    id: String = UUID().uuidString,
    title: String = "unknown",
    tags: [String] = [],
    allDay: Bool = false,
    attendees: [String] = [],
    now: Date = Date(),
    startDate: Date = Date(),
    endDate: Date = Date(),
    services: [String: String] = [:]
  ) -> Event {
    let cal = PlanCalendar.Unknown
    let title = Title(text: title)
    let schedule = Schedule(
      now: now,
      startDate: startDate,
      endDate: endDate,
      allDay: allDay
    )
    let location = ""
    let meeting = Meeting(organizer: "", attendees: attendees)

    return Event(
      id: id,
      calendar: cal,
      title: title,
      schedule: schedule,
      location: location,
      meeting: meeting,
      services: services,
      tags: tags
    )
  }

  /// An empty/unknown default event
  static let Empty: Event = generate()
}

/// Extension to String for finding tags in the text
extension String {
  /// Finds and returns an array of tags in the string
  /// Tags are in the format "tag:value"
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
  /// Convenience method to build services URLs from EKEvent
  func listServices() -> [String: String] {
    return Dictionary(uniqueKeysWithValues: Service.fromEvent(
      notes: notes ?? "",
      calendarItemIdentifier: calendarItemIdentifier,
      isAllDay: isAllDay,
      hasRecurrenceRules: hasRecurrenceRules,
      startDate: startDate
    ).map { key, value in (key.rawValue, value) }
    )
  }

  /// Converts an EKEvent to an Event struct
  func asEvent() -> Event {
    guard let startDate = startDate, let endDate = endDate else {
      fatalError("Event start or end date is missing")
    }

    return Event(
      id: calendarItemIdentifier,
      calendar: calendar?.asCal() ?? PlanCalendar.Unknown,
      title: Title(text: title ?? "Unknown"),
      schedule: Schedule(
        now: Date(),
        startDate: startDate,
        endDate: endDate,
        allDay: isAllDay
      ),
      location: location ?? "",
      meeting: Meeting(
        organizer: organizer?.name ?? "",
        attendees: (attendees ?? [EKParticipant]()).asString()
      ),
      services: listServices(),
      tags: notes?.findTags() ?? []
    )
  }
}

extension [Event] {
  /// Prints the array of Events as JSON
  func renderAsJson() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    encoder.outputFormatting = [.withoutEscapingSlashes, .prettyPrinted]
    do {
      let data = try encoder.encode(self)
      if let json = String(
        data: data,
        encoding: .utf8
      ) {
        return json
      }
    } catch {
      StdErr.print("Failed to print events as JSON")
    }
    // guru exception
    return nil
  }
}

extension Event {
  static let titleLens = Lens<Event, Title>(
    get: { event in event.title },
    set: { title, event in Event(
      id: event.id,
      calendar: event.calendar,
      title: title,
      schedule: event.schedule,
      location: event.location,
      meeting: event.meeting,
      services: event.services,
      tags: event.tags
    ) }
  )
}

extension KeyedEncodingContainer {
  mutating func encode(_ value: String, forKey key: K) throws {
    // omit empty strings from serialization
    guard !value.isEmpty else { return }
    try encodeIfPresent(value, forKey: key)
  }
}
