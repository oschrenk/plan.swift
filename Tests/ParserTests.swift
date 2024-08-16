@testable import plan
import XCTest

final class ParserTests: XCTestCase {
  func testParse() {
    // arrange
    let input = "foo"

    // act
    let output = Parser.parse(text: input)

    // assert
    let expected = AddEvent(
      title: input,
      startsAt: Date(),
      endsAt: Date(),
      notes: "Some notes"
    )

    XCTAssertEqual(output.title, expected.title, "The title was not correct")
  }
}
