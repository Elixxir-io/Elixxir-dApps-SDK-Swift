import Bindings

public struct Connection {
  public var getId: ConnectionIdProvider
  public var isAuthenticated: ConnectionAuthStatusProvider
  public var getPartner: ConnectionPartnerProvider
  public var send: MessageSender
  public var listen: MessageListener
  public var close: ConnectionCloser
}

extension Connection {
  public static func live(
    bindingsConnection: BindingsConnection
  ) -> Connection {
    Connection(
      getId: .live(bindingsConnection: bindingsConnection),
      isAuthenticated: .live(bindingsConnection: bindingsConnection),
      getPartner: .live(bindingsConnection: bindingsConnection),
      send: .live(bindingsConnection: bindingsConnection),
      listen: .live(bindingsConnection: bindingsConnection),
      close: .live(bindingsConnection: bindingsConnection)
    )
  }

  public static func live(
    bindingsAuthenticatedConnection: BindingsAuthenticatedConnection
  ) -> Connection {
    Connection(
      getId: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection),
      isAuthenticated: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection),
      getPartner: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection),
      send: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection),
      listen: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection),
      close: .live(bindingsAuthenticatedConnection: bindingsAuthenticatedConnection)
    )
  }
}

#if DEBUG
extension Connection {
  public static let failing = Connection(
    getId: .failing,
    isAuthenticated: .failing,
    getPartner: .failing,
    send: .failing,
    listen: .failing,
    close: .failing
  )
}
#endif