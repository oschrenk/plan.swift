@testable import plan
import XCTest

final class ParserTests: XCTestCase {
  func testParseWithLeadingDash() {
    let input = "- 10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = Parser.parse(text: input)!

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }

  func testParseWithoutLeadingDash() {
    let input = "10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = Parser.parse(text: input)!

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }

  func testParseTag() {
    let input = "10:00 - 12:00 🥗 Lunch #calendar/foo"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: "calendar/foo"
    )
    let output = Parser.parse(text: input)!

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
    XCTAssertEqual(output.tag, expected.tag, "The title was not correct")
  }
}
