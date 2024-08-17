@testable import plan
import XCTest

final class ParserTests: XCTestCase {
  func testParse() {
    // arrange
    let input = "- 10:00 - 12:00 🥗 Lunch"

    // act
    let output = Parser.parse(text: input)!

    // assert
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date()
    )

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }
}
