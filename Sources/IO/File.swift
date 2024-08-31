import Foundation

enum File {
  static func read(from path: String) -> String? {
    let url = URL(fileURLWithPath: path)
    do {
      return try String(contentsOf: url, encoding: .utf8)
    } catch {
      return nil
    }
  }
}
