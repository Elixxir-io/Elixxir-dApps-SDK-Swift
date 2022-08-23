import Foundation
import XXClient
import XCTestDynamicOverlay

public struct MessengerEnvironment {
  public var cMix: Stored<CMix?>
  public var downloadNDF: DownloadAndVerifySignedNdf
  public var e2e: Stored<E2E?>
  public var fileManager: MessengerFileManager
  public var generateSecret: GenerateSecret
  public var getCMixParams: GetCMixParams
  public var getE2EParams: GetE2EParams
  public var isRegisteredWithUD: IsRegisteredWithUD
  public var loadCMix: LoadCMix
  public var login: Login
  public var ndfEnvironment: NDFEnvironment
  public var newCMix: NewCMix
  public var newOrLoadUd: NewOrLoadUd
  public var passwordStorage: PasswordStorage
  public var sleep: (Int) -> Void
  public var storageDir: String
  public var ud: Stored<UserDiscovery?>
  public var udAddress: String?
  public var udCert: Data?
  public var udContact: Data?
}

extension MessengerEnvironment {
  public static let defaultStorageDir = FileManager.default
    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
    .first!
    .appendingPathComponent("xx.network.client")
    .path

  public static func live() -> MessengerEnvironment {
    MessengerEnvironment(
      cMix: .inMemory(),
      downloadNDF: .live,
      e2e: .inMemory(),
      fileManager: .live(),
      generateSecret: .live,
      getCMixParams: .liveDefault,
      getE2EParams: .liveDefault,
      isRegisteredWithUD: .live,
      loadCMix: .live,
      login: .live,
      ndfEnvironment: .mainnet,
      newCMix: .live,
      newOrLoadUd: .live,
      passwordStorage: .keychain,
      sleep: { Foundation.sleep(UInt32($0)) },
      storageDir: MessengerEnvironment.defaultStorageDir,
      ud: .inMemory(),
      udAddress: nil,
      udCert: nil,
      udContact: nil
    )
  }
}

extension MessengerEnvironment {
  public static let unimplemented = MessengerEnvironment(
    cMix: .unimplemented(),
    downloadNDF: .unimplemented,
    e2e: .unimplemented(),
    fileManager: .unimplemented,
    generateSecret: .unimplemented,
    getCMixParams: .unimplemented,
    getE2EParams: .unimplemented,
    isRegisteredWithUD: .unimplemented,
    loadCMix: .unimplemented,
    login: .unimplemented,
    ndfEnvironment: .unimplemented,
    newCMix: .unimplemented,
    newOrLoadUd: .unimplemented,
    passwordStorage: .unimplemented,
    sleep: XCTUnimplemented("\(Self.self).sleep"),
    storageDir: "unimplemented",
    ud: .unimplemented(),
    udAddress: nil,
    udCert: nil,
    udContact: nil
  )
}
