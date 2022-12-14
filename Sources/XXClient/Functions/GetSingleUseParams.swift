import Bindings
import XCTestDynamicOverlay

public struct GetSingleUseParams {
  public var run: () -> Data

  public func callAsFunction() -> Data {
    run()
  }
}

extension GetSingleUseParams {
  public static let liveDefault = GetSingleUseParams {
    guard let data = BindingsGetDefaultSingleUseParams() else {
      fatalError("BindingsGetDefaultSingleUseParams returned `nil`")
    }
    return data
  }
}

extension GetSingleUseParams {
  public static let unimplemented = GetSingleUseParams(
    run: XCTUnimplemented("\(Self.self)", placeholder: "unimplemented".data(using: .utf8)!)
  )
}
