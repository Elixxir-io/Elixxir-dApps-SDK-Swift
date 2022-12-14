import XCTestDynamicOverlay
import XXClient

public struct MessengerListenForMessages {
  public enum Error: Swift.Error, Equatable {
    case notConnected
  }

  public var run: () throws -> Void

  public func callAsFunction() throws -> Void {
    try run()
  }
}

extension MessengerListenForMessages {
  public static func live(_ env: MessengerEnvironment) -> MessengerListenForMessages {
    MessengerListenForMessages {
      do {
        guard let e2e = env.e2e() else {
          throw Error.notConnected
        }
        try e2e.registerListener(
          senderId: nil,
          messageType: 2,
          callback: env.messageListeners.registered()
        )
        env.isListeningForMessages.set(true)
      } catch {
        env.isListeningForMessages.set(false)
        throw error
      }
    }
  }
}

extension MessengerListenForMessages {
  public static let unimplemented = MessengerListenForMessages(
    run: XCTUnimplemented("\(Self.self)")
  )
}
