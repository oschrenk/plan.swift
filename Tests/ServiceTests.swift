@testable import plan
import Testing

@Suite final class ServiceTests {
  @Test func testEmptyNotes() {
    let input = ""
    let expected = Service.fromNotes(notes: input)
    let output: [Service: String] = [:]

    #expect(output == expected)
  }

  @Test func testMeetNotes() {
    let input = "https://meet.google.com/ped-jqsa-fkv"
    let output = Service.fromNotes(notes: input)
    let expected: [Service: String] = [Service.meet: input]

    #expect(output == expected)
  }

  @Test func testZoomNotes() {
    let input = "https://us02web.zoom.us/j/89669654995"
    let output = Service.fromNotes(notes: input)
    let expected: [Service: String] = [Service.zoom: input]

    #expect(output == expected)
  }
}
