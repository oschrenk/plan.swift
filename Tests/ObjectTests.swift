@testable import plan
import XCTest

final class ObjectTests: XCTestCase {
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

  func testKeyPathOnKeywords() {
    let event = genEvent(title: "test")
    do {
      let expected = try Object.valueForKeyPath(event, "schedule.start.in") as? Int ?? -1
      let output = 0

      XCTAssertEqual(output, expected, "The fields were not the same")
    } catch {
      XCTFail("Expected no error, but got \(error)")
    }
  }

  func testNotComparable() {
    let event = genEvent(title: "test")
    do {
      XCTAssertThrowsError(try Object.valueForKeyPath(event, "schedule.start")) { error in
        XCTAssertTrue(
          error is Object.PathError,
          "Unexpected error type: \(type(of: error))"
        )

        XCTAssertEqual(error as? Object.PathError, .notComparable)
      }
    }
  }
}
