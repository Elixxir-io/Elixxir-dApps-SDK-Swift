import XXClient

public struct Messenger {
  public var cMix: Stored<CMix?>
  public var e2e: Stored<E2E?>
  public var ud: Stored<UserDiscovery?>
  public var backup: Stored<Backup?>
  public var isCreated: MessengerIsCreated
  public var create: MessengerCreate
  public var restoreBackup: MessengerRestoreBackup
  public var isLoaded: MessengerIsLoaded
  public var load: MessengerLoad
  public var registerAuthCallbacks: MessengerRegisterAuthCallbacks
  public var registerMessageListener: MessengerRegisterMessageListener
  public var start: MessengerStart
  public var isConnected: MessengerIsConnected
  public var connect: MessengerConnect
  public var isListeningForMessages: MessengerIsListeningForMessages
  public var listenForMessages: MessengerListenForMessages
  public var isRegistered: MessengerIsRegistered
  public var register: MessengerRegister
  public var isLoggedIn: MessengerIsLoggedIn
  public var logIn: MessengerLogIn
  public var waitForNetwork: MessengerWaitForNetwork
  public var waitForNodes: MessengerWaitForNodes
  public var destroy: MessengerDestroy
  public var searchContacts: MessengerSearchContacts
  public var lookupContact: MessengerLookupContact
  public var lookupContacts: MessengerLookupContacts
  public var registerForNotifications: MessengerRegisterForNotifications
  public var verifyContact: MessengerVerifyContact
  public var sendMessage: MessengerSendMessage
  public var registerBackupCallback: MessengerRegisterBackupCallback
  public var isBackupRunning: MessengerIsBackupRunning
  public var startBackup: MessengerStartBackup
  public var resumeBackup: MessengerResumeBackup
  public var backupParams: MessengerBackupParams
  public var stopBackup: MessengerStopBackup
}

extension Messenger {
  public static func live(_ env: MessengerEnvironment) -> Messenger {
    Messenger(
      cMix: env.cMix,
      e2e: env.e2e,
      ud: env.ud,
      backup: env.backup,
      isCreated: .live(env),
      create: .live(env),
      restoreBackup: .live(env),
      isLoaded: .live(env),
      load: .live(env),
      registerAuthCallbacks: .live(env),
      registerMessageListener: .live(env),
      start: .live(env),
      isConnected: .live(env),
      connect: .live(env),
      isListeningForMessages: .live(env),
      listenForMessages: .live(env),
      isRegistered: .live(env),
      register: .live(env),
      isLoggedIn: .live(env),
      logIn: .live(env),
      waitForNetwork: .live(env),
      waitForNodes: .live(env),
      destroy: .live(env),
      searchContacts: .live(env),
      lookupContact: .live(env),
      lookupContacts: .live(env),
      registerForNotifications: .live(env),
      verifyContact: .live(env),
      sendMessage: .live(env),
      registerBackupCallback: .live(env),
      isBackupRunning: .live(env),
      startBackup: .live(env),
      resumeBackup: .live(env),
      backupParams: .live(env),
      stopBackup: .live(env)
    )
  }
}

extension Messenger {
  public static let unimplemented = Messenger(
    cMix: .unimplemented(),
    e2e: .unimplemented(),
    ud: .unimplemented(),
    backup: .unimplemented(),
    isCreated: .unimplemented,
    create: .unimplemented,
    restoreBackup: .unimplemented,
    isLoaded: .unimplemented,
    load: .unimplemented,
    registerAuthCallbacks: .unimplemented,
    registerMessageListener: .unimplemented,
    start: .unimplemented,
    isConnected: .unimplemented,
    connect: .unimplemented,
    isListeningForMessages: .unimplemented,
    listenForMessages: .unimplemented,
    isRegistered: .unimplemented,
    register: .unimplemented,
    isLoggedIn: .unimplemented,
    logIn: .unimplemented,
    waitForNetwork: .unimplemented,
    waitForNodes: .unimplemented,
    destroy: .unimplemented,
    searchContacts: .unimplemented,
    lookupContact: .unimplemented,
    lookupContacts: .unimplemented,
    registerForNotifications: .unimplemented,
    verifyContact: .unimplemented,
    sendMessage: .unimplemented,
    registerBackupCallback: .unimplemented,
    isBackupRunning: .unimplemented,
    startBackup: .unimplemented,
    resumeBackup: .unimplemented,
    backupParams: .unimplemented,
    stopBackup: .unimplemented
  )
}
