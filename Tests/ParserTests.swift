@testable import plan
import XCTest

final class ParserTests: XCTestCase {
  func testParseWithLeadingDash() {
    // arrange
    let input = "- 10:00 - 12:00 🥗 Lunch"

    // act
    let output = Parser.parse(text: input)!

    // assert
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }

  func testParseWithoutLeadingDash() {
    // arrange
    let input = "10:00 - 12:00 🥗 Lunch"

    // act
    let output = Parser.parse(text: input)!

    // assert
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }

  func testParseTag() {
    // arrange
    let input = "10:00 - 12:00 🥗 Lunch #calendar/foo"

    // act
    let output = Parser.parse(text: input)!

    // assert
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: "calendar/foo"
    )

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
    XCTAssertEqual(output.tag, expected.tag, "The title was not correct")
  }
}
