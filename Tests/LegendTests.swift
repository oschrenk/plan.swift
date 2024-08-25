@testable import plan
import XCTest

final class LegendTests: XCTestCase {
  func testWithoutEmoji() {
    let input = "Banana"
    let expected = Legend(description: "Banana", icon: "")
    let output = input.asLegend()

    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }

  func testLeadingSimpleEmoji() {
    let input = "🍌 Banana"
    let expected = Legend(description: "Banana", icon: "🍌")
    let output = input.asLegend()

    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }

  func testLeadingCombinedEmoji() {
    // 'Thumbs up' with 'Emoji Modifier Fitzpatrick Type-4':
    let input = "👍🏽 Thumb"
    let expected = Legend(description: "Thumb", icon: "👍🏽")
    let output = input.asLegend()

    XCTAssertEqual(output, expected, "The emoji was not correctly extracted")
  }
}
