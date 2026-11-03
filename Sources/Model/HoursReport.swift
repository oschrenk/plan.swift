import Foundation

/// Hours per day and title
///
/// An event counts in full on the day it starts. Events that start outside of
/// the period don't count.
struct HoursReport: Equatable {
  let total: Double
  let days: [Day]

  struct Day: Equatable {
    let date: Date
    let total: Double
    let titles: [String: Double]
  }

  private static let MinutesPerHour = 60.0
  private static let DayLabelFormat = "yyyy-MM-dd EEE"
  private static let HoursFormat = "%6.2f"
  private static let TitleIndent = "  "
  private static let TotalLabel = "Total"

  static func build(events: [Event], period: DateInterval, calendar: FCalendar) -> HoursReport {
    let eventsByDay = Dictionary(grouping: events) {
      calendar.startOfDay(for: $0.schedule.start.at)
    }

    var days: [Day] = []
    var totalMinutes = 0
    var day = period.start
    while day < period.end {
      let minutes = Dictionary(grouping: eventsByDay[day] ?? []) { $0.title.full }
        .mapValues { $0.reduce(into: 0) { $0 += $1.schedule.duration } }
      let dayMinutes = minutes.values.reduce(0, +)
      totalMinutes += dayMinutes
      days.append(Day(
        date: day,
        total: Double(dayMinutes) / MinutesPerHour,
        titles: minutes.mapValues { Double($0) / MinutesPerHour }
      ))
      day = calendar.date(byAdding: .day, value: 1, to: day)!
    }

    return HoursReport(total: Double(totalMinutes) / MinutesPerHour, days: days)
  }

  func renderAsText() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = Self.DayLabelFormat

    let rows = days.flatMap { day in
      [(formatter.string(from: day.date), day.total)] +
        day.titles.sorted { $0.key < $1.key }.map { (Self.TitleIndent + $0.key, $0.value) }
    } + [(Self.TotalLabel, total)]

    let width = rows.map { Self.displayWidth($0.0) }.max() ?? 0
    return rows.map { label, hours in
      let padding = String(repeating: " ", count: width - Self.displayWidth(label))
      return "\(label)\(padding) \(String(format: Self.HoursFormat, hours))"
    }.joined(separator: "\n")
  }

  /// Terminals draw emoji such as title icons two columns wide
  private static func displayWidth(_ text: String) -> Int {
    text.reduce(0) {
      $0 + ($1.unicodeScalars.first?.properties.isEmojiPresentation == true ? 2 : 1)
    }
  }
}
