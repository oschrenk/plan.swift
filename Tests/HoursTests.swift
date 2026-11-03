import Foundation
@testable import plan
import Testing

final class HoursTests {
  private let cal: FCalendar = {
    var cal = FCalendar(identifier: .gregorian)
    cal.firstWeekday = 2
    return cal
  }()

  private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
    cal.date(from: DateComponents(year: year, month: month, day: day))!
  }

  @Test func currentWeekContainsNow() {
    let week = Hours.week(weeksAgo: 0, now: date(2026, 11, 4), calendar: cal)

    #expect(week == DateInterval(start: date(2026, 11, 2), end: date(2026, 11, 9)))
  }

  @Test func weeksAgoReachesEarlierWeek() {
    let week = Hours.week(weeksAgo: 2, now: date(2026, 11, 2), calendar: cal)

    #expect(week == DateInterval(start: date(2026, 10, 19), end: date(2026, 10, 26)))
  }

  @Test func weeksAgoCrossesYearBoundary() {
    let week = Hours.week(weeksAgo: 1, now: date(2026, 1, 1), calendar: cal)

    #expect(week == DateInterval(start: date(2025, 12, 22), end: date(2025, 12, 29)))
  }

  @Test func acceptsNoArguments() throws {
    let hours = try Hours.parse([])

    #expect(hours.expression == nil)
    #expect(hours.weeksAgo == nil)
  }

  @Test func rejectsDateTogetherWithWeeksAgo() {
    #expect(throws: (any Error).self) {
      try Hours.parse(["--weeks-ago", "1", "2026-10-19"])
    }
  }

  @Test func rejectsNegativeWeeksAgo() {
    #expect(throws: (any Error).self) {
      try Hours.parse(["--weeks-ago=-1"])
    }
  }
}
