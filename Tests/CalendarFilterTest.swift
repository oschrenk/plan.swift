import EventKit
import Testing

@testable import plan

@Suite final class CalendarFilterTests {
  @Test func testAlwaysAccept() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Accept().accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func testSelectCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Select(uuids: [calendar.id]).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func testSelectCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Select(uuids: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func testIgnoreCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = false
    let actual = CalendarFilter.Ignore(uuids: [calendar.id]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func testIgnoreCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Ignore(uuids: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func testIgnoreCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.IgnoreSources(sources: [source]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func testIgnoreCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreSources(sources: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func testSelectCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: [source]).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func testSelectCalendarSourcesNotMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.SelectSources(sources: ["not-existing"]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func testSelectCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func testIgnoreCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.IgnoreTypes(types: [type]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func testIgnoreCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreTypes(types: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func testSelectCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: [type]).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func testSelectCalendarTypesNotMatching() {
    let type = EKCalendarType.calDAV
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.SelectTypes(types: [EKCalendarType.birthday]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func testSelectCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }
}
