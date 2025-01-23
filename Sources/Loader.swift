import Foundation

enum Loader {
  private static let appName = "plan"
  private static let defaultConfigHome = FileManager.default
    .homeDirectoryForCurrentUser
    .appendingPathComponent(".config")
  private static let xdgConfigHome = ProcessInfo.processInfo.environment["XDG_CONFIG_HOME"]
    .map { URL(fileURLWithPath: $0) }
  private static let configHome = xdgConfigHome ?? defaultConfigHome

  private static let configDir = configHome.appendingPathComponent(appName)
  private static let configUrl = configDir.appendingPathComponent("config.json")

  private static func readLocalJSON<T: Codable>(from path: String, as _: T.Type) -> T? {
    let url = URL(fileURLWithPath: path)

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      print("Error reading or decoding file at \(path): \(error)")
      return nil
    }
  }

  static func readConfig() -> Config? {
    if let config: Config = readLocalJSON(from: configUrl.path, as: Config.self) {
      return config
    } else {
      print("Failed to read JSON file.")
      return nil
    }
  }
}
