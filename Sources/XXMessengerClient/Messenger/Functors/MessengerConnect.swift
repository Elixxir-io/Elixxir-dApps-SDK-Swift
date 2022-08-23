import XXClient
import XCTestDynamicOverlay

public struct MessengerConnect {
  public enum Error: Swift.Error, Equatable {
    case notLoaded
  }

  public var run: () throws -> Void

  public func callAsFunction() throws {
    try run()
  }
}

extension MessengerConnect {
  public static func live(_ env: MessengerEnvironment) -> MessengerConnect {
    MessengerConnect {
      guard let cMix = env.cMix() else {
        throw Error.notLoaded
      }
      env.e2e.set(try env.login(
        cMixId: cMix.getId(),
        identity: try cMix.makeLegacyReceptionIdentity(),
        e2eParamsJSON: env.getE2EParams()
      ))
    }
  }
}

extension MessengerConnect {
  public static let unimplemented = MessengerConnect(
    run: XCTUnimplemented("\(Self.self)")
  )
}
