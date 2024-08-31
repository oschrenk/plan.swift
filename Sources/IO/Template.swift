import Foundation
import Stencil

class Template {
  static func render(path: String, events: [Event]) -> String? {
    let template = File.read(from: path)

    if template == nil {
      return nil
    }
    let ext = Extension()
    ext.registerFilter("format") { (value: Any?, arguments: [Any?]) in
      let format: String

      if let value = arguments.first as? String {
        format = value
      } else {
        throw TemplateSyntaxError("not a valid format")
      }

      if let value = value as? Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: value)
      }

      return value
    }

    let context = ["events": events]
    let environment = Environment(
      loader: DictionaryLoader(templates: ["default": template!]),
      extensions: [ext]
    )
    do {
      return try environment.renderTemplate(name: "default", context: context)
    } catch {
      StdErr.print("Error rendering template: \(error)")
      return nil
    }
  }
}
