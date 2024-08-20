import Foundation

enum StdIn {
  /// Check if stdin received data.
  /// - Returns: True if data is available
  static func hasData() -> Bool {
    guard let inputStream = InputStream(fileAtPath: "/dev/stdin") else {
      return false
    }
    inputStream.open()
    defer { inputStream.close() }
    return inputStream.hasBytesAvailable
  }

  /// Return stdin lines as array
  /// - Returns: Array of strings
  static func readLines() -> [String] {
    return AnyIterator { Swift.readLine() }.map { $0 }
  }
}
