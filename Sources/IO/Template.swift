import Stencil

class Template {
  static func render(path: String, events: [Event]) -> String? {
    let template = File.read(from: path)

    if template == nil {
      return nil
    }

    let context = ["events": events]
    let environment = Environment(loader: DictionaryLoader(templates: ["default": template!]))
    let rendered = try! environment.renderTemplate(name: "default", context: context)

    return rendered
  }
}
