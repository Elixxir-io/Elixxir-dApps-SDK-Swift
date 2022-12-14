import CustomDump
import XCTest
import XXClient
@testable import XXMessengerClient

final class MessengerBackupParamsTests: XCTestCase {
  func testBackupParams() throws {
    var didAddJSON: [String] = []
    let params = "test-123"

    var env: MessengerEnvironment = .unimplemented
    env.backup.get = {
      var backup: Backup = .unimplemented
      backup.isRunning.run = { true }
      backup.addJSON.run = { didAddJSON.append($0) }
      return backup
    }
    let backup: MessengerBackupParams = .live(env)

    try backup(params)

    XCTAssertNoDifference(didAddJSON, [params])
  }

  func testBackupParamsWhenNoBackup() {
    var env: MessengerEnvironment = .unimplemented
    env.backup.get = { nil }
    let backup: MessengerBackupParams = .live(env)

    XCTAssertThrowsError(try backup("")) { error in
      XCTAssertNoDifference(
        error as NSError,
        MessengerBackupParams.Error.notRunning as NSError
      )
    }
  }

  func testBackupParamsWhenBackupNotRunning() {
    var env: MessengerEnvironment = .unimplemented
    env.backup.get = {
      var backup: Backup = .unimplemented
      backup.isRunning.run = { false }
      return backup
    }
    let backup: MessengerBackupParams = .live(env)

    XCTAssertThrowsError(try backup("")) { error in
      XCTAssertNoDifference(
        error as NSError,
        MessengerBackupParams.Error.notRunning as NSError
      )
    }
  }
}
