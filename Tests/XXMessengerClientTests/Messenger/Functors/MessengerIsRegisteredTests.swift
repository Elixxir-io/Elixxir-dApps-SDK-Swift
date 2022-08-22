import XCTest
@testable import XXMessengerClient

final class MessengerIsRegisteredTests: XCTestCase {
  func testRegistered() throws {
    var didIsRegisteredWithUD: [Int] = []

    var env: MessengerEnvironment = .unimplemented
    env.ctx.e2e = .unimplemented
    env.ctx.e2e!.getId.run = { 1234 }
    env.isRegisteredWithUD.run = { e2eId in
      didIsRegisteredWithUD.append(e2eId)
      return true
    }
    let isRegistered: MessengerIsRegistered = .live(env)

    XCTAssertTrue(try isRegistered())
    XCTAssertEqual(didIsRegisteredWithUD, [1234])
  }

  func testNotRegistered() throws {
    var env: MessengerEnvironment = .unimplemented
    env.ctx.e2e = .unimplemented
    env.ctx.e2e!.getId.run = { 1234 }
    env.isRegisteredWithUD.run = { _ in false }
    let isRegistered: MessengerIsRegistered = .live(env)

    XCTAssertFalse(try isRegistered())
  }

  func testWithoutE2E() {
    let env: MessengerEnvironment = .unimplemented
    env.ctx.e2e = nil
    let isRegistered: MessengerIsRegistered = .live(env)

    XCTAssertThrowsError(try isRegistered()) { err in
      XCTAssertEqual(
        err as? MessengerIsRegistered.Error,
        MessengerIsRegistered.Error.notConnected
      )
    }
  }

  func testIsRegisteredWithUDFailure() {
    struct Error: Swift.Error, Equatable {}
    let error = Error()

    var env: MessengerEnvironment = .unimplemented
    env.ctx.e2e = .unimplemented
    env.ctx.e2e!.getId.run = { 1234 }
    env.isRegisteredWithUD.run = { _ in throw error }
    let isRegistered: MessengerIsRegistered = .live(env)

    XCTAssertThrowsError(try isRegistered()) { err in
      XCTAssertEqual(err as? Error, error)
    }
  }
}
