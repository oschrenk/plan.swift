import EventKit

struct Calendar: Codable {
  let id: String
  let label: String
}

extension EKCalendar {
  func asCal() -> Calendar {
    let id = calendarIdentifier
    let label = title

    return Calendar(
      id: id,
      label: label
    )
  }
}

extension [Calendar] {
  func printAsJson() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    encoder.outputFormatting = .prettyPrinted
    do {
      let json = try String(
        decoding: encoder.encode(self),
        as: UTF8.self
      )
      print(json)
    } catch {
      print("fail")
    }
  }
}
