import CustomDump
import XCTest
import XXClient
@testable import XXMessengerClient

final class MessengerDestroyTests: XCTestCase {
  func testDestroy() throws {
    let storageDir = "test-storage-dir"
    var hasRunningProcesses: [Bool] = [true, true, false]
    var didStopNetworkFollower = 0
    var didSleep: [TimeInterval] = []
    var didRemoveItem: [String] = []
    var didSetGroupChat: [GroupChat?] = []
    var didSetFileTransfer: [FileTransfer?] = []
    var didSetBackup: [Backup?] = []
    var didSetUD: [UserDiscovery?] = []
    var didSetE2E: [E2E?] = []
    var didSetCMix: [CMix?] = []
    var didRemovePassword = 0
    var didSetIsListeningForMessages: [Bool] = []
    var didSetServiceList: [MessageServiceList?] = []

    var env: MessengerEnvironment = .unimplemented
    env.cMix.get = {
      var cMix: CMix = .unimplemented
      cMix.networkFollowerStatus.run = { .running }
      cMix.stopNetworkFollower.run = { didStopNetworkFollower += 1 }
      cMix.hasRunningProcesses.run = { hasRunningProcesses.removeFirst() }
      return cMix
    }
    env.sleep = { didSleep.append($0) }
    env.storageDir = storageDir
    env.groupChat.set = { didSetGroupChat.append($0) }
    env.fileTransfer.set = { didSetFileTransfer.append($0) }
    env.backup.set = { didSetBackup.append($0) }
    env.ud.set = { didSetUD.append($0) }
    env.e2e.set = { didSetE2E.append($0) }
    env.cMix.set = { didSetCMix.append($0) }
    env.isListeningForMessages.set = { didSetIsListeningForMessages.append($0) }
    env.serviceList.set = { didSetServiceList.append($0) }
    env.fileManager.removeItem = { didRemoveItem.append($0) }
    env.passwordStorage.remove = { didRemovePassword += 1 }
    let destroy: MessengerDestroy = .live(env)

    try destroy()

    XCTAssertNoDifference(didStopNetworkFollower, 1)
    XCTAssertNoDifference(didSleep, [1, 1])
    XCTAssertNoDifference(didSetGroupChat.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetFileTransfer.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetBackup.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetUD.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetE2E.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetCMix.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetIsListeningForMessages, [false])
    XCTAssertNoDifference(didSetServiceList.map { $0 == nil }, [true])
    XCTAssertNoDifference(didRemoveItem, [storageDir])
    XCTAssertNoDifference(didRemovePassword, 1)
  }

  func testStopNetworkFollowerFailure() {
    struct Error: Swift.Error, Equatable {}
    let error = Error()

    var env: MessengerEnvironment = .unimplemented
    env.cMix.get = {
      var cMix: CMix = .unimplemented
      cMix.networkFollowerStatus.run = { .running }
      cMix.stopNetworkFollower.run = { throw error }
      return cMix
    }
    let destroy: MessengerDestroy = .live(env)

    XCTAssertThrowsError(try destroy()) { err in
      XCTAssertEqual(err as? Error, error)
    }
  }

  func testRemoveDirectoryFailure() {
    struct Error: Swift.Error, Equatable {}
    let error = Error()
    var didSetGroupChat: [GroupChat?] = []
    var didSetFileTransfer: [FileTransfer?] = []
    var didSetBackup: [Backup?] = []
    var didSetUD: [UserDiscovery?] = []
    var didSetE2E: [E2E?] = []
    var didSetCMix: [CMix?] = []
    var didSetIsListeningForMessages: [Bool] = []
    var didSetServiceList: [MessageServiceList?] = []

    var env: MessengerEnvironment = .unimplemented
    env.cMix.get = { nil }
    env.groupChat.set = { didSetGroupChat.append($0) }
    env.fileTransfer.set = { didSetFileTransfer.append($0) }
    env.backup.set = { didSetBackup.append($0) }
    env.ud.set = { didSetUD.append($0) }
    env.e2e.set = { didSetE2E.append($0) }
    env.cMix.set = { didSetCMix.append($0) }
    env.isListeningForMessages.set = { didSetIsListeningForMessages.append($0) }
    env.serviceList.set = { didSetServiceList.append($0) }
    env.fileManager.removeItem = { _ in throw error }
    let destroy: MessengerDestroy = .live(env)

    XCTAssertThrowsError(try destroy()) { err in
      XCTAssertEqual(err as? Error, error)
    }
    XCTAssertNoDifference(didSetGroupChat.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetFileTransfer.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetBackup.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetUD.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetE2E.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetCMix.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetIsListeningForMessages, [false])
    XCTAssertNoDifference(didSetServiceList.map { $0 == nil }, [true])
  }

  func testRemovePasswordFailure() {
    struct Error: Swift.Error, Equatable {}
    let error = Error()
    let storageDir = "test-storage-dir"
    var didRemoveItem: [String] = []
    var didSetGroupChat: [GroupChat?] = []
    var didSetFileTransfer: [FileTransfer?] = []
    var didSetBackup: [Backup?] = []
    var didSetUD: [UserDiscovery?] = []
    var didSetE2E: [E2E?] = []
    var didSetCMix: [CMix?] = []
    var didSetIsListeningForMessages: [Bool] = []
    var didSetServiceList: [MessageServiceList?] = []

    var env: MessengerEnvironment = .unimplemented
    env.cMix.get = { nil }
    env.groupChat.set = { didSetGroupChat.append($0) }
    env.fileTransfer.set = { didSetFileTransfer.append($0) }
    env.backup.set = { didSetBackup.append($0) }
    env.ud.set = { didSetUD.append($0) }
    env.e2e.set = { didSetE2E.append($0) }
    env.cMix.set = { didSetCMix.append($0) }
    env.isListeningForMessages.set = { didSetIsListeningForMessages.append($0) }
    env.serviceList.set = { didSetServiceList.append($0) }
    env.storageDir = storageDir
    env.fileManager.removeItem = { didRemoveItem.append($0) }
    env.passwordStorage.remove = { throw error }
    let destroy: MessengerDestroy = .live(env)

    XCTAssertThrowsError(try destroy()) { err in
      XCTAssertEqual(err as? Error, error)
    }
    XCTAssertNoDifference(didSetGroupChat.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetFileTransfer.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetBackup.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetUD.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetE2E.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetCMix.map { $0 == nil }, [true])
    XCTAssertNoDifference(didSetIsListeningForMessages, [false])
    XCTAssertNoDifference(didSetServiceList.map { $0 == nil }, [true])
    XCTAssertNoDifference(didRemoveItem, [storageDir])
  }
}
