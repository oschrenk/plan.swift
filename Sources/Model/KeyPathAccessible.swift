protocol KeyPathAccessible: Codable {
  static func codingKey(for key: String) -> CodingKey?
}
