import ComposableArchitecture
import XCTest
@testable import AppFeature

final class AppFeatureTests: XCTestCase {
  func testViewDidLoad() throws {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: .failing
    )

    store.send(.viewDidLoad)
  }
}
