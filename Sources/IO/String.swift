import Foundation

// From
// https://github.com/dirtyhenry/swift-blocks/blob/4e6b2fb079edb0ab0951a8fce061ee308c9d3503/Sources/Blocks/Extensions/StringProtocol.swift

public extension StringProtocol {
  /// Converts the string into a URL-friendly slug.
  ///
  /// This method transforms the string to lowercase, removes accents and combining marks, replaces spaces and
  /// non-alphanumeric characters with hyphens, and trims leading and trailing hyphens.
  ///
  /// - Returns: A URL-friendly slug representation of the string.
  ///
  /// # Usage Example #
  /// ```
  /// let exampleString = "Hello, World! This is an example string with accents: é, è, ê, ñ."
  /// let slugifiedString = exampleString.slugify()
  /// print(slugifiedString)  // Output: "hello-world-this-is-an-example-string-with-accents-e-e-e-n"
  /// ```
  func slugify() -> String {
    var slug = lowercased()

    // Remove accents and combining marks
    slug = slug.applyingTransform(.toLatin, reverse: false) ?? slug
    slug = slug.applyingTransform(.stripDiacritics, reverse: false) ?? slug
    slug = slug.applyingTransform(.stripCombiningMarks, reverse: false) ?? slug

    // Replace spaces and non-alphanumeric characters with hyphens
    slug = slug.replacingOccurrences(
      of: "[\\+]+", with: "+plus+", options: .regularExpression
    )
    slug = slug.replacingOccurrences(
      of: "[^a-z0-9]+", with: "-", options: .regularExpression
    )

    // Trim hyphens from the start and end
    slug = slug.trimmingCharacters(in: CharacterSet(charactersIn: "-"))

    if !isEmpty, slug.isEmpty {
      if let extendedSelf = applyingTransform(.toUnicodeName, reverse: false)?
        .replacingOccurrences(of: "\\N", with: ""), self != extendedSelf
      // swiftlint:disable:next opening_brace
      {
        return extendedSelf.slugify()
      }
    }

    return slug
  }
}
