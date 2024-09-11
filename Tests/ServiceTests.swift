@testable import plan
import XCTest

final class ServiceTests: XCTestCase {
  func testEmptyNotes() {
    let input = ""
    let expected = Service.fromNotes(notes: input)
    let output: [Service: String] = [:]

    XCTAssertEqual(output, expected, "The notes were not empty")
  }

  func testMeetNotes() {
    let input = "https://meet.google.com/ped-jqsa-fkv"
    let expected = Service.fromNotes(notes: input)
    let output: [Service: String] = [Service.meet: input]

    XCTAssertEqual(output, expected, "The notes did not match")
  }
}
