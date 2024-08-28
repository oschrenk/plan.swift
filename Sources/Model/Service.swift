import Foundation

class Service {
  private static let services: [String: String] = [
    "meet": #"https://meet\.google\.com/[a-z]{3}-[a-z]{4}-[a-z]{3}"#,
  ]

  private static func findMatch(in text: String, using pattern: String) -> String? {
    let regex = try! Regex<Substring>(pattern)
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
  ) -> [String: String] {
    var matches = fromNotes(notes: notes)
    matches["ical"] = buildIcalURL(
      calendarItemIdentifier: calendarItemIdentifier,
      isAllDay: isAllDay,
      hasRecurrenceRules: hasRecurrenceRules,
      startDate: startDate
    )
    return matches
  }

  static func fromNotes(notes: String) -> [String: String] {
    var matches: [String: String] = [:]

    for (name, pattern) in services {
      let match = findMatch(in: notes, using: pattern)
      if match != nil {
        matches[name] = match
      }
    }

    return matches
  }

  // generate the url to show the event in the Calendar.app
  //   "ical://ekevent/\(startTimeAsIso)/\(event.calendarItemIdentifier)?method=show&options=more"
  // with
  //   `startTimeAsIso` in "yyyyMMdd'T'HHmmss'Z'"
  //   `calendaritemidentifier` being the
  //
  // the method is basically a copy of https://github.com/raycast/extensions/blob/36abdaacac9b02cbbc54dbe33f16b6c40cd23f54/extensions/menubar-calendar/swift/AppleReminders/Sources/Calendar.swift#L61
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
