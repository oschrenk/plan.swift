@testable import plan
import XCTest

final class SampleTests: XCTestCase {
  func testWithoutEmoji() {
    // arrange
    let input = "Banana"

    // act
    let output = input.asLegend()

    // assert
    let expected = Legend(description: "Banana", icon: "")
    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }

  func testLeadingSimpleEmoji() {
    // arrange
    let input = "🍌 Banana"

    // act
    let output = input.asLegend()

    // assert
    let expected = Legend(description: "Banana", icon: "🍌")
    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }

  func testLeadingCombinedEmoji() {
    // arrange
    // 'Thumbs up' with 'Emoji Modifier Fitzpatrick Type-4':
    let input = "👍🏽 Thumb"

    // act
    let output = input.asLegend()

    // assert
    let expected = Legend(description: "Thumb", icon: "👍🏽")
    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }
}
