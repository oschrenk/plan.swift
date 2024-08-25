import Foundation

class Service {
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
