import Foundation
@testable import plan
import Testing

@Suite final class ParserTests {
  @Test func testParseWithLeadingDash() {
    let input = "- 10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = Parser.parse(text: input)!

    #expect(output.title == expected.title)
  }

  @Test func testParseWithoutLeadingDash() {
    let input = "10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = Parser.parse(text: input)!

    #expect(output.title == expected.title)
  }

  @Test func testParseTag() {
    let input = "10:00 - 12:00 🥗 Lunch #calendar/foo"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: "calendar/foo"
    )
    let output = Parser.parse(text: input)!

    #expect(output.title == expected.title)
    #expect(output.tag == expected.tag)
  }
}
