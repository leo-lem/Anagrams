//	Created by Leopold Lemmermann on 07.11.22.

import Foundation

@available(iOS 16, macOS 13, *)
public func sleep(for duration: Duration) async {
  try? await Task.sleep(for: duration)
}
