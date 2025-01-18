import EventKit

@testable import plan
import XCTest

final class CalendarFilterTests: XCTestCase {
  func testAlwaysAccept() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Accept().accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Select(uuids: [calendar.id]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Select(uuids: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = false
    let actual = CalendarFilter.Ignore(uuids: [calendar.id]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Ignore(uuids: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.IgnoreSources(sources: [source]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreSources(sources: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: [source]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesNotMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.SelectSources(sources: ["not-existing"]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testIgnoreCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.IgnoreTypes(types: [type]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreTypes(types: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: [type]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesNotMatching() {
    let type = EKCalendarType.calDAV
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.SelectTypes(types: [EKCalendarType.birthday]).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: []).accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }
}
