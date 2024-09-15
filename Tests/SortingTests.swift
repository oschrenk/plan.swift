@testable import plan
import XCTest

final class SortingTests: XCTestCase {
  private func genEvent(
    title: String = "unknown",
    tags: [String] = [],
    allDay: Bool = false,
    attendees: [String] = []
  ) -> Event {
    let id = UUID().uuidString
    let cal = PlanCalendar.Unknown
    let title = Title(text: title)
    let schedule = Schedule(
      now: Date(),
      startDate: Date(),
      endDate: Date(),
      allDay: allDay
    )
    let location = ""
    let meeting = Meeting(organizer: "", attendees: attendees)
    let services: [Service: String] = [:]

    return Event(
      id: id,
      calendar: cal,
      title: title,
      schedule: schedule,
      location: location,
      meeting: meeting,
      services: services,
      tags: tags
    )
  }

  func testValidSortingPath() {
    let event = genEvent(title: "test")
    let expected = Sorting.valueForKeyPath(event, "title.full") as? String ?? "FAIL"
    let output = "test"

    XCTAssertEqual(output, expected, "The fields were not the same")
  }

  func testKeyPathOnKeywords() {
    let event = genEvent(title: "test")
    let expected = Sorting.valueForKeyPath(event, "schedule.start.in") as? Int ?? -1
    let output = 0

    XCTAssertEqual(output, expected, "The fields were not the same")
  }
}
