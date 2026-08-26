import EventKit
@testable import plan
import Testing

final class CalendarFilterTests {
  @Test func alwaysAccept() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.Accept().accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func selectCalendarIdMatching() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectIds(uuids: [calendar.id]).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func selectCalendarIdsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectIds(uuids: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func ignoreCalendarIdMatching() {
    let calendar = PlanCalendar.generate()
    let expected = false
    let actual = CalendarFilter.IgnoreIds(uuids: [calendar.id]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func ignoreCalendarIdsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreIds(uuids: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func selectCalendarLabelMatching() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectLabels(labels: [calendar.label]).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func selectCalendarLabelsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectLabels(labels: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func ignoreCalendarLabelMatching() {
    let calendar = PlanCalendar.generate()
    let expected = false
    let actual = CalendarFilter.IgnoreLabels(labels: [calendar.label]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func ignoreCalendarLabelsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreLabels(labels: []).accept(calendar)

    #expect(actual == expected, "The calendar was not accepted")
  }

  @Test func ignoreCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.IgnoreSources(sources: [source]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func ignoreCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreSources(sources: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func selectCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: [source]).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func selectCalendarSourcesNotMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.SelectSources(sources: ["not-existing"]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func selectCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectSources(sources: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func ignoreCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.IgnoreTypes(types: [type]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func ignoreCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.IgnoreTypes(types: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func selectCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: [type]).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }

  @Test func selectCalendarTypesNotMatching() {
    let type = EKCalendarType.calDAV
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.SelectTypes(types: [EKCalendarType.birthday]).accept(calendar)

    #expect(actual == expected, "The calendar was accepted")
  }

  @Test func selectCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.SelectTypes(types: []).accept(calendar)

    #expect(actual == expected, "The calendar was rejected")
  }
}
