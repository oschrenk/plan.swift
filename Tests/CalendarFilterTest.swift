import EventKit

@testable import plan
import XCTest

final class CalendarFilterTests: XCTestCase {
  private func genCalendar(
    type: EKCalendarType = EKCalendarType.calDAV,
    source: String = "Test"
  ) -> PlanCalendar {
    let id = "5E28ECB5-A07D-4FC8-82E4-5F37C38C786F"
    let label = "Test"
    let color = "#FFB3E4"

    return PlanCalendar(
      id: id,
      type: type.description,
      source: source,
      label: label,
      color: color
    )
  }

  func testAlwaysAccept() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsMatching() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.select(uuids: [calendar.id])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.select(uuids: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarsMatching() {
    let calendar = genCalendar()
    let expected = false
    let actual = CalendarFilter.ignore(uuids: [calendar.id])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarsEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.ignore(uuids: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = genCalendar(source: source)
    let expected = false
    let actual = CalendarFilter.ignoreSources(sources: [source])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarSourcesEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.ignoreSources(sources: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = genCalendar(source: source)
    let expected = true
    let actual = CalendarFilter.selectSources(sources: [source])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesNotMatching() {
    let source = "Personal"
    let calendar = genCalendar(source: source)
    let expected = false
    let actual = CalendarFilter.selectSources(sources: ["not-existing"])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarSourcesEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.selectSources(sources: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testIgnoreCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = genCalendar(type: type)
    let expected = false
    let actual = CalendarFilter.ignoreTypes(types: [type])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarTypesEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.ignoreTypes(types: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = genCalendar(type: type)
    let expected = true
    let actual = CalendarFilter.selectTypes(types: [type])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesNotMatching() {
    let type = EKCalendarType.calDAV
    let calendar = genCalendar(type: type)
    let expected = false
    let actual = CalendarFilter.selectTypes(types: [EKCalendarType.birthday])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarTypesEmptyArray() {
    let calendar = genCalendar()
    let expected = true
    let actual = CalendarFilter.selectTypes(types: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }
}
