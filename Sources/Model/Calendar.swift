import EventKit

struct Calendar: Codable {
  let id: String
  let label: String
  let color: String
  let type: String
}

extension CGColor {
  func asHexString() -> String {
    let components = components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0

    let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    return hexString
  }
}

extension EKCalendarType: CustomStringConvertible {
  public var description: String {
    switch self {
    case .local:
      return "local"
    case .calDAV:
      return "caldav"
    case .exchange:
      return "exchange"
    case .subscription:
      return "subscription"
    case .birthday:
      return "birthday"
    default:
      return "unknown"
    }
  }
}

extension EKCalendar {
  func asCal() -> Calendar {
    let id = calendarIdentifier
    let label = title
    let color = cgColor.asHexString()
    let type = type.description

    return Calendar(
      id: id,
      label: label,
      color: color,
      type: type
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
      StdOut.print(json)
    } catch {
      StdErr.print("fail")
    }
  }

  func printAsPlain() {
    let sorted = self.sorted(by: { cal1, cal2 in
      cal1.label < cal2.label
    })
    for calendar in sorted {
      StdOut.print("\(calendar.id) \(calendar.label)")
    }
  }
}
