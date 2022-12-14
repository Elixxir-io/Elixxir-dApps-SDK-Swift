import Foundation
import Logging
import XCTestDynamicOverlay
import XXClient

public struct MessengerStartLogging {
  public var run: () -> Void

  public func callAsFunction() -> Void {
    run()
  }
}

extension MessengerStartLogging {
  public static func live(_ env: MessengerEnvironment) -> MessengerStartLogging {
    return MessengerStartLogging {
      env.registerLogWriter(.init { messageString in
        env.logger(.parse(messageString))
      })
    }
  }
}

extension MessengerStartLogging {
  public static let unimplemented = MessengerStartLogging(
    run: XCTUnimplemented("\(Self.self)")
  )
}
