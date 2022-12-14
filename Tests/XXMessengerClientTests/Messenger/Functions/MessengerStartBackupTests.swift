import CustomDump
import XCTest
import XXClient
@testable import XXMessengerClient

final class MessengerStartBackupTests: XCTestCase {
  func testStartWithParams() throws {
    struct InitBackupParams: Equatable {
      var e2eId: Int
      var udId: Int
      var password: String
    }
    var didInitializeBackup: [InitBackupParams] = []
    var backupCallbacks: [UpdateBackupFunc] = []
    var didHandleCallback: [Data] = []
    var didSetBackup: [Backup?] = []
    var didAddJSON: [String] = []

    let params = "backup-params"
    let password = "test-password"
    let e2eId = 123
    let udId = 321
    let dataWithoutParams = "backup-without-params".data(using: .utf8)!
    let dataWithParams = "backup-with-params".data(using: .utf8)!

    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { didSetBackup.last as? Backup }
    env.backup.set = { didSetBackup.append($0) }
    env.e2e.get = {
      var e2e: E2E = .unimplemented
      e2e.getId.run = { e2eId }
      return e2e
    }
    env.ud.get = {
      var ud: UserDiscovery = .unimplemented
      ud.getId.run = { udId }
      return ud
    }
    env.backupCallbacks.registered = {
      UpdateBackupFunc { didHandleCallback.append($0) }
    }
    env.initializeBackup.run = { e2eId, udId, password, callback in
      didInitializeBackup.append(.init(e2eId: e2eId, udId: udId, password: password))
      backupCallbacks.append(callback)
      var backup: Backup = .unimplemented
      backup.addJSON.run = { string in
        didAddJSON.append(string)
      }
      return backup
    }
    let start: MessengerStartBackup = .live(env)

    try start(password: password, params: params)

    XCTAssertNoDifference(didInitializeBackup, [
      .init(e2eId: e2eId, udId: udId, password: password)
    ])
    XCTAssertNoDifference(didSetBackup.map { $0 != nil }, [true])

    backupCallbacks.forEach { $0.handle(dataWithoutParams) }

    XCTAssertNoDifference(
      didHandleCallback.map(StringData.init),
      [].map(StringData.init)
    )
    XCTAssertNoDifference(didAddJSON, [params])

    backupCallbacks.forEach { $0.handle(dataWithParams) }

    XCTAssertNoDifference(
      didHandleCallback.map(StringData.init),
      [dataWithParams].map(StringData.init)
    )
  }

  func testStartWithoutParams() throws {
    struct InitBackupParams: Equatable {
      var e2eId: Int
      var udId: Int
      var password: String
    }
    var didInitializeBackup: [InitBackupParams] = []
    var backupCallbacks: [UpdateBackupFunc] = []
    var didHandleCallback: [Data] = []
    var didSetBackup: [Backup?] = []

    let password = "test-password"
    let e2eId = 123
    let udId = 321
    let dataWithoutParams = "backup-without-params".data(using: .utf8)!

    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { didSetBackup.last as? Backup }
    env.backup.set = { didSetBackup.append($0) }
    env.e2e.get = {
      var e2e: E2E = .unimplemented
      e2e.getId.run = { e2eId }
      return e2e
    }
    env.ud.get = {
      var ud: UserDiscovery = .unimplemented
      ud.getId.run = { udId }
      return ud
    }
    env.backupCallbacks.registered = {
      UpdateBackupFunc { didHandleCallback.append($0) }
    }
    env.initializeBackup.run = { e2eId, udId, password, callback in
      didInitializeBackup.append(.init(e2eId: e2eId, udId: udId, password: password))
      backupCallbacks.append(callback)
      return .unimplemented
    }
    let start: MessengerStartBackup = .live(env)

    try start(password: password)

    XCTAssertNoDifference(didInitializeBackup, [
      .init(e2eId: e2eId, udId: udId, password: password)
    ])
    XCTAssertNoDifference(didSetBackup.map { $0 != nil }, [true])

    backupCallbacks.forEach { $0.handle(dataWithoutParams) }

    XCTAssertNoDifference(
      didHandleCallback.map(StringData.init),
      [dataWithoutParams].map(StringData.init)
    )
  }

  func testStartWhenRunning() {
    var env: MessengerEnvironment = .unimplemented
    env.backup.get = {
      var backup: Backup = .unimplemented
      backup.isRunning.run = { true }
      return backup
    }
    let start: MessengerStartBackup = .live(env)

    XCTAssertThrowsError(try start(password: "")) { error in
      XCTAssertNoDifference(
        error as NSError,
        MessengerStartBackup.Error.isRunning as NSError
      )
    }
  }

  func testStartWhenNotConnected() {
    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { nil }
    env.e2e.get = { nil }
    let start: MessengerStartBackup = .live(env)

    XCTAssertThrowsError(try start(password: "")) { error in
      XCTAssertNoDifference(
        error as NSError,
        MessengerStartBackup.Error.notConnected as NSError
      )
    }
  }

  func testStartWhenNotLoggedIn() {
    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { nil }
    env.e2e.get = { .unimplemented }
    env.ud.get = { nil }
    let start: MessengerStartBackup = .live(env)

    XCTAssertThrowsError(try start(password: "")) { error in
      XCTAssertNoDifference(
        error as NSError,
        MessengerStartBackup.Error.notLoggedIn as NSError
      )
    }
  }

  func testStartFailure() {
    struct Failure: Error, Equatable {}
    let failure = Failure()

    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { nil }
    env.e2e.get = {
      var e2e: E2E = .unimplemented
      e2e.getId.run = { 123 }
      return e2e
    }
    env.ud.get = {
      var ud: UserDiscovery = .unimplemented
      ud.getId.run = { 321 }
      return ud
    }
    env.backupCallbacks.registered = { UpdateBackupFunc { _ in  } }
    env.initializeBackup.run = { _, _, _, _ in throw failure }
    let start: MessengerStartBackup = .live(env)

    XCTAssertThrowsError(try start(password: "")) { error in
      XCTAssertNoDifference(error as NSError, failure as NSError)
    }
  }
}
