import ArgumentParser
import Foundation

enum Service: String, Codable, ExpressibleByArgument {
  case ical, meet, zoom

  private static let servicePatterns: [Service: String] = [
    Service.meet: #"https:\/\/meet\.google\.com/[a-z]{3}-[a-z]{4}-[a-z]{3}"#,
    Service.zoom: #"https://(?:[a-zA-Z0-9-.]+)?zoom\.(?:us|com|com\.cn|de)\/(?:my|[a-z]{1,2}|webinar)\/[-a-zA-Z0-9()@:%_\+.~#?&=\/]*"#,
  ]

  private static func findMatch(in text: String, using pattern: String) -> String? {
    guard let regex = try? Regex<Substring>(pattern) else {
      StdErr.print("Error creating regex for pattern: \(pattern)")
      return nil
    }

    if let match = text.firstMatch(of: regex) {
      return String(match.output)
    }
    return nil
  }

  static func fromEvent(
    notes: String,
    calendarItemIdentifier: String,
    isAllDay: Bool,
    hasRecurrenceRules: Bool,
    startDate: Date?
  ) -> [Service: String] {
    var matches = fromNotes(notes: notes)
    matches[Service.ical] = buildIcalURL(
      calendarItemIdentifier: calendarItemIdentifier,
      isAllDay: isAllDay,
      hasRecurrenceRules: hasRecurrenceRules,
      startDate: startDate
    )
    return matches
  }

  static func fromNotes(notes: String) -> [Service: String] {
    servicePatterns.compactMapValues { pattern in
      findMatch(in: notes, using: pattern)
    }
  }

  /// Generate the url to show the event in the Calendar.app
  ///
  /// Format:
  ///   "ical://ekevent/\(startTimeAsIso)/\(event.calendarItemIdentifier)?method=show&options=more"
  /// with
  ///   `startTimeAsIso` in "yyyyMMdd'T'HHmmss'Z'"
  ///   `calendaritemidentifier` being the
  ///
  /// See also https://github.com/raycast/extensions/blob/36abdaacac9b02cbbc54dbe33f16b6c40cd23f54/extensions/menubar-calendar/swift/AppleReminders/Sources/Calendar.swift#L61
  static func buildIcalURL(
    calendarItemIdentifier: String,
    isAllDay: Bool,
    hasRecurrenceRules: Bool,
    startDate: Date?
  ) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
    formatter.timeZone = TimeZone.current

    var dateComponent = ""
    if hasRecurrenceRules {
      if let startDate = startDate {
        formatter.timeZone = TimeZone.current
        if !isAllDay {
          formatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        dateComponent = "/\(formatter.string(from: startDate))"
      }
    }

    return "ical://ekevent\(dateComponent)/\(calendarItemIdentifier)?method=show&options=more"
  }
}
