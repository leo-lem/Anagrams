// Created by Leopold Lemmermann on 12.02.25.

import OSLog

public func runtimeWarning(_ message: StaticString, condition: Bool = true) {
#if DEBUG
  if condition {
    var info = Dl_info()
    dladdr(
      dlsym(
        dlopen(nil, RTLD_LAZY),
        "$s10Foundation15AttributeScopesO7SwiftUIE05swiftE0AcDE0D12UIAttributesVmvg"
      ),
      &info
    )

    os_log(
      .fault,
      dso: info.dli_fbase,
      log: OSLog(
        subsystem: "com.apple.runtime-issues",
        category: "Extensions"
      ),
      message
    )
  }
#endif
}
