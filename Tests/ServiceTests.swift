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

  @Test func testTeamsNotes() {
    let input = "https://teams.microsoft.com/l/meetup-join/19%3ameeting_MzI2YmRlNTgtMTU0MC00NmNhLWIzMmQtODg0ZGVmMGEwOTc3%40thread.v2/0?context=%7b%22Tid%22%3a%22c2ad6337-37a8-446a-ba48-18f44ea87c3d%22%2c%22Oid%22%3a%2230e7d7d2-057e-4d2f-8fa5-0475c962dded%22%7d"
    let output = Service.fromNotes(notes: input)
    let expected: [Service: String] = [Service.teams: input]

    #expect(output == expected)
  }
}
