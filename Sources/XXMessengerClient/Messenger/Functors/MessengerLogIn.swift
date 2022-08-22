import XXClient
import XCTestDynamicOverlay

public struct MessengerLogIn {
  public enum Error: Swift.Error, Equatable {
    case notLoaded
    case notConnected
  }

  public var run: () throws -> Void

  public func callAsFunction() throws {
    try run()
  }
}

extension MessengerLogIn {
  public static func live(_ env: MessengerEnvironment) -> MessengerLogIn {
    MessengerLogIn {
      guard let cMix = env.ctx.cMix else {
        throw Error.notLoaded
      }
      guard let e2e = env.ctx.e2e else {
        throw Error.notConnected
      }
      if cMix.networkFollowerStatus() != .running {
        try cMix.startNetworkFollower(timeoutMS: 30_000)
      }
      env.ctx.ud = try env.newOrLoadUd(
        params: .init(
          e2eId: e2e.getId(),
          username: nil,
          registrationValidationSignature: nil,
          cert: env.udCert() ?? e2e.getUdCertFromNdf(),
          contactFile: env.udContact() ?? (try e2e.getUdContactFromNdf()),
          address: env.udAddress() ?? e2e.getUdAddressFromNdf()
        ),
        follower: .init {
          cMix.networkFollowerStatus().rawValue
        }
      )
    }
  }
}

extension MessengerLogIn {
  public static let unimplemented = MessengerLogIn(
    run: XCTUnimplemented()
  )
}
