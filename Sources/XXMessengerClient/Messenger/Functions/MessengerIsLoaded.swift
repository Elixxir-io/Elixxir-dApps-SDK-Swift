import XXClient
import XCTestDynamicOverlay

public struct MessengerIsLoaded {
  public var run: () -> Bool

  public func callAsFunction() -> Bool {
    run()
  }
}

extension MessengerIsLoaded {
  public static func live(_ env: MessengerEnvironment) -> MessengerIsLoaded {
    MessengerIsLoaded {
      env.cMix() != nil
    }
  }
}

extension MessengerIsLoaded {
  public static let unimplemented = MessengerIsLoaded(
    run: XCTUnimplemented("\(Self.self)", placeholder: false)
  )
}
