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
    let chars = Array(self)

    guard let firstChar = chars.first else {
      return Legend(description: "", icon: "")
    }

    var description = self
    var icon = ""

    if firstChar.isEmoji {
      description = String(chars.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
      icon = String(firstChar)
    }

    return Legend(description: description, icon: icon)
  }
}
