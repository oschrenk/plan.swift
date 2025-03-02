
class Printer {
  func print(events: [Event], templatePath: String) {
    if templatePath.isEmpty {
      if let render = events.renderAsJson() {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render JSON")
      }
    } else {
      if let template = Template(path: templatePath) {
        if let render = template.render(events: events) {
          StdOut.print(render)
        } else {
          StdErr.print("Failed to render template at `\(templatePath)`")
        }
      } else {
        StdErr.print("Failed to load template at `\(templatePath)`")
      }
    }
  }
}
