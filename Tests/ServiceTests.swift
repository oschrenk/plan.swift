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
    let expected = Service.fromNotes(notes: input)
    let output: [Service: String] = [Service.meet: input]

    #expect(output == expected)
  }
}
