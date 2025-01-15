@testable import plan
import XCTest

final class ObjectTests: XCTestCase {
  func testKeyPathOnKeywords() {
    let event = Event.generate(title: "test")
    do {
      let expected = try Object.valueForKeyPath(event, "schedule.start.in") as? Int ?? -1
      let output = 0

      XCTAssertEqual(output, expected, "The fields were not the same")
    } catch {
      XCTFail("Expected no error, but got \(error)")
    }
  }

  func testNotComparable() {
    let event = Event.generate(title: "test")
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
