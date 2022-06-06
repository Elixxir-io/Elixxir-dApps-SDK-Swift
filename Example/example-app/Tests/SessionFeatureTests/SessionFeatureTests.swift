import ComposableArchitecture
import XCTest
@testable import SessionFeature

final class SessionFeatureTests: XCTestCase {
  func testViewDidLoad() throws {
    let store = TestStore(
      initialState: SessionState(id: UUID()),
      reducer: sessionReducer,
      environment: .failing
    )

    store.send(.viewDidLoad)
  }
}
