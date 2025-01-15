import EventKit

struct PlanCalendar: Codable, ReverseCodable {
  /// id of the calendar
  let id: String
  /// type of the calendar
  let type: String
  /// source of the calendar
  let source: String
  /// label of the calendar
  let label: String
  /// color of the calendar
  let color: String

  /// Generate a new PlanCalendar
  static func generate(
    type: EKCalendarType = EKCalendarType.calDAV,
    label: String = "Test",
    source: String = "Test",
    color: String = "#FFB3E4"
  ) -> PlanCalendar {
    let id = UUID().uuidString

    return PlanCalendar(
      id: id,
      type: type.description,
      source: source,
      label: label,
      color: color
    )
  }

  static let Unknown = PlanCalendar(
    id: "unknown",
    type: "unknown",
    source: "unknown",
    label: "No Label",
    color: "#FFFFFF"
  )

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case type
    case source
    case label
    case color
  }

  static func reverseCodingKeys() -> [String: String] {
    return [
      CodingKeys.id.rawValue: "id",
      CodingKeys.type.rawValue: "type",
      CodingKeys.source.rawValue: "source",
      CodingKeys.label.rawValue: "label",
      CodingKeys.color.rawValue: "color",
    ]
  }
}

extension CGColor {
  func asHexString() -> String {
    let components = components
    let red: CGFloat = components?[0] ?? 0.0
    let green: CGFloat = components?[1] ?? 0.0
    let blue: CGFloat = components?[2] ?? 0.0

    let hexString = String(
      format: "#%02lX%02lX%02lX",
      lroundf(Float(red * 255)),
      lroundf(Float(green * 255)),
      lroundf(Float(blue * 255))
    )
    return hexString
  }
}

extension EventKit.EKCalendarType: Swift.CustomStringConvertible {
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
  func asCal() -> PlanCalendar {
    let id = calendarIdentifier
    let type = type.description
    let source = source.title
    let label = title
    let color = cgColor.asHexString()

    return PlanCalendar(
      id: id,
      type: type,
      source: source,
      label: label,
      color: color
    )
  }
}

extension [PlanCalendar] {
  func printAsJson() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    encoder.outputFormatting = .prettyPrinted
    do {
      let data = try encoder.encode(self)
      if let json = String(
        data: data,
        encoding: .utf8
      ) {
        StdOut.print(json)
      }
    } catch {
      StdErr.print("fail")
    }
  }

  func printAsPlain() {
    let sorted = self.sorted(by: { cal1, cal2 in
      cal1.label < cal2.label
    })
    for calendar in sorted {
      StdOut.print("\(calendar.id) \(calendar.label) \(calendar.type) \(calendar.source)")
    }
  }
}
