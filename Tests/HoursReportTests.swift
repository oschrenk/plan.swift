import Foundation
@testable import plan
import Testing

final class HoursReportTests {
  private let cal = FCalendar.current

  private func date(_ day: Int, _ hour: Int = 0) -> Date {
    cal.date(from: DateComponents(year: 2026, month: 10, day: day, hour: hour))!
  }

  private func event(_ title: String, from start: Date, to end: Date) -> Event {
    Event.generate(title: title, now: start, startDate: start, endDate: end)
  }

  @Test func listsEveryDayAndSplitsTitles() {
    let report = HoursReport.build(
      events: [
        event("A", from: date(19, 9), to: date(19, 11)),
        event("A", from: date(19, 12), to: date(19, 13)),
        event("B", from: date(19, 14), to: date(19, 15)),
      ],
      period: DateInterval(start: date(19), end: date(21)),
      calendar: cal
    )

    #expect(report.total == 4)
    #expect(report.days.map(\.date) == [date(19), date(20)])
    #expect(report.days[0].titles == ["A": 3, "B": 1])
    #expect(report.days[0].total == 4)
    #expect(report.days[1].titles.isEmpty)
    #expect(report.days[1].total == 0)
  }

  @Test func countsEventsOnceOnTheirStartDay() {
    let report = HoursReport.build(
      events: [
        event("before", from: date(18, 23), to: date(19, 1)),
        event("overnight", from: date(19, 23), to: date(20, 1)),
        event("after", from: date(21, 0), to: date(21, 1)),
      ],
      period: DateInterval(start: date(19), end: date(21)),
      calendar: cal
    )

    #expect(report.total == 2)
    #expect(report.days[0].titles == ["overnight": 2])
    #expect(report.days[1].titles.isEmpty)
  }

  @Test func alignsTextWithIconsAndSortsTitles() {
    let report = HoursReport.build(
      events: [
        event("🕐 Timewax", from: date(19, 9), to: date(19, 14)),
        event("Calls", from: date(19, 14), to: date(19, 15)),
      ],
      period: DateInterval(start: date(19), end: date(21)),
      calendar: cal
    )

    #expect(report.renderAsText() == """
    2026-10-19 Mon   6.00
      Calls          1.00
      🕐 Timewax     5.00
    2026-10-20 Tue   0.00
    Total            6.00
    """)
  }

  @Test func rendersJsonWithPlainDates() throws {
    let report = HoursReport.build(
      events: [event("A", from: date(19, 9), to: date(19, 10))],
      period: DateInterval(start: date(19), end: date(20)),
      calendar: cal
    )

    let json = try #require(report.renderAsJson())
    let object = try #require(
      JSONSerialization.jsonObject(with: Data(json.utf8)) as? [String: Any]
    )
    let days = try #require(object["days"] as? [[String: Any]])

    #expect(Set(object.keys) == ["total", "days"])
    #expect(days[0]["date"] as? String == "2026-10-19")
    #expect(days[0]["titles"] as? [String: Double] == ["A": 1])
  }
}
