import Foundation

public extension Bundle {
  subscript(string key: String) -> String {
    let value = object(forInfoDictionaryKey: key) as? String
    runtimeWarning("Missing Info.plist key in Bundle.", condition: value == nil)
    return value ?? key
  }

  subscript(url key: String) -> URL {
    let url = URL(string: self[string: key])
    runtimeWarning("Invalid URL loaded from Bundle.", condition: url == nil)
    return url ?? URL(fileURLWithPath: "/dev/null")
  }
}
