import Bindings
import XCTestDynamicOverlay

public struct HealthCallback {
  public init(handle: @escaping (Bool) -> Void) {
    self.handle = handle
  }

  public var handle: (Bool) -> Void
}

extension HealthCallback {
  public static let unimplemented = HealthCallback(
    handle: XCTUnimplemented("\(Self.self)")
  )
}

extension HealthCallback {
  func makeBindingsHealthCallback() -> BindingsNetworkHealthCallbackProtocol {
    class Callback: NSObject, BindingsNetworkHealthCallbackProtocol {
      init(_ healthCallback: HealthCallback) {
        self.healthCallback = healthCallback
      }

      let healthCallback: HealthCallback

      func callback(_ p0: Bool) {
        healthCallback.handle(p0)
      }
    }

    return Callback(self)
  }
}
