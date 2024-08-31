struct Title: Codable {
  let full: String
  let label: String
  let icon: String

  init(text: String) {
    full = text
    let legend = full.asLegend()
    label = legend.description
    icon = legend.icon
  }
}

struct Legend: Codable, Equatable {
  let description: String
  let icon: String

  static func == (lhs: Legend, rhs: Legend) -> Bool {
    lhs.description == rhs.description &&
      lhs.icon == rhs.icon
  }

  static let Empty = Legend(description: "", icon: "")
}

extension Character {
  var isSimpleEmoji: Bool {
    guard let firstScalar = unicodeScalars.first else {
      return false
    }
    return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
  }

  var isCombinedIntoEmoji: Bool {
    unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
  }

  var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
  func asLegend() -> Legend {
    guard let firstChar = first else {
      return Legend.Empty
    }

    if firstChar.isEmoji {
      let description = String(dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
      return Legend(description: description, icon: String(firstChar))
    }

    return Legend(description: self, icon: "")
  }
}
