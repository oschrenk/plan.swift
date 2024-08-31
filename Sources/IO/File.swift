import Foundation

enum File {
  static func read(from path: String) -> String? {
    do {
      let url = URL(fileURLWithPath: path)
      return try String(contentsOf: url, encoding: .utf8)
    } catch {
      return nil
    }
  }
}
