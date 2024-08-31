import Foundation

class FileWatcher {
  private let minSeconds = 2
  private var lastChange = Int(Date().timeIntervalSince1970)

  private var sources: [Int32: DispatchSourceFileSystemObject] = [:]
  private let queue = DispatchQueue.global()

  private let paths: [String]
  private let callback: () -> Void

  init(paths: [String], callback: @escaping () -> Void) {
    self.paths = paths
    self.callback = callback
  }

  func start() {
    for path in paths {
      let isMonitoring = monitorFile(path: path)
      if !isMonitoring {
        StdErr.print("Not monitoring \(path)")
      }
    }
  }

  private func monitorFile(path: String) -> Bool {
    let fileDescriptor = open(path, O_EVTONLY)
    guard fileDescriptor != -1 else { return false }

    let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: [.write, .delete, .rename, .extend, .attrib], queue: queue)

    source.setEventHandler { [weak self] in
      guard let self = self else { return }
      let event = source.data

      if event.contains(.delete) || event.contains(.rename) {
        self.stopMonitoring(fileDescriptor)
      } else if event.contains(.write) || event.contains(.extend) || event.contains(.attrib) {
        self.handleWriteEvent(at: path)
      }
    }

    source.setCancelHandler {
      close(fileDescriptor)
    }

    source.resume()
    sources[fileDescriptor] = source

    return true
  }

  private func stopMonitoring(_ fileDescriptor: Int32) {
    sources[fileDescriptor]?.cancel()
    sources.removeValue(forKey: fileDescriptor)
  }

  private func handleWriteEvent(at _: String) {
    let now = Int(Date().timeIntervalSince1970)
    if now - lastChange < minSeconds {
    } else {
      lastChange = now
      callback()
    }
  }

  deinit {
    for (fileDescriptor, source) in sources {
      source.cancel()
      close(fileDescriptor)
    }
  }
}
