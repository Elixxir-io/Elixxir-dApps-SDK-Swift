import AppCore
import Combine
import ComposableArchitecture
import CustomDump
import XCTest
import XXClient
import XXMessengerClient
import XXModels
@testable import ChatFeature

final class ChatFeatureTests: XCTestCase {
  func testStart() {
    let contactId = "contact-id".data(using: .utf8)!
    let myContactId = "my-contact-id".data(using: .utf8)!

    let store = TestStore(
      initialState: ChatState(id: .contact(contactId)),
      reducer: chatReducer,
      environment: .unimplemented
    )

    var didFetchMessagesWithQuery: [XXModels.Message.Query] = []
    let messagesPublisher = PassthroughSubject<[XXModels.Message], Error>()
    var didFetchFileTransfersWithQuery: [XXModels.FileTransfer.Query] = []
    let fileTransfersPublisher = PassthroughSubject<[XXModels.FileTransfer], Error>()

    store.environment.mainQueue = .immediate
    store.environment.bgQueue = .immediate
    store.environment.messenger.e2e.get = {
      var e2e: E2E = .unimplemented
      e2e.getContact.run = {
        var contact: XXClient.Contact = .unimplemented(Data())
        contact.getIdFromContact.run = { _ in myContactId }
        return contact
      }
      return e2e
    }
    store.environment.db.run = {
      var db: Database = .unimplemented
      db.fetchMessagesPublisher.run = { query in
        didFetchMessagesWithQuery.append(query)
        return messagesPublisher.eraseToAnyPublisher()
      }
      db.fetchFileTransfersPublisher.run = { query in
        didFetchFileTransfersWithQuery.append(query)
        return fileTransfersPublisher.eraseToAnyPublisher()
      }
      return db
    }

    store.send(.start) {
      $0.myContactId = myContactId
    }

    XCTAssertNoDifference(didFetchMessagesWithQuery, [
      .init(chat: .direct(myContactId, contactId))
    ])
    XCTAssertNoDifference(didFetchFileTransfersWithQuery, [
      .init(contactId: contactId, isIncoming: true),
      .init(contactId: myContactId, isIncoming: false),
    ])

    let receivedFileTransfer = FileTransfer(
      id: "file-transfer-1-id".data(using: .utf8)!,
      contactId: contactId,
      name: "file-transfer-1-name",
      type: "file-transfer-1-type",
      isIncoming: true
    )
    let sentFileTransfer = FileTransfer(
      id: "file-transfer-2-id".data(using: .utf8)!,
      contactId: myContactId,
      name: "file-transfer-2-name",
      type: "file-transfer-2-type",
      isIncoming: false
    )
    messagesPublisher.send([
      .init(
        id: nil,
        senderId: contactId,
        recipientId: myContactId,
        groupId: nil,
        date: Date(timeIntervalSince1970: 0),
        status: .received,
        isUnread: false,
        text: "Message 0"
      ),
      .init(
        id: 1,
        senderId: contactId,
        recipientId: myContactId,
        groupId: nil,
        date: Date(timeIntervalSince1970: 1),
        status: .received,
        isUnread: false,
        text: "Message 1",
        fileTransferId: receivedFileTransfer.id
      ),
      .init(
        id: 2,
        senderId: myContactId,
        recipientId: contactId,
        groupId: nil,
        date: Date(timeIntervalSince1970: 2),
        status: .sent,
        isUnread: false,
        text: "Message 2",
        fileTransferId: sentFileTransfer.id
      ),
    ])
    fileTransfersPublisher.send([
      receivedFileTransfer,
      sentFileTransfer,
    ])

    let expectedMessages = IdentifiedArrayOf<ChatState.Message>(uniqueElements: [
      .init(
        id: 1,
        date: Date(timeIntervalSince1970: 1),
        senderId: contactId,
        text: "Message 1",
        status: .received,
        fileTransfer: receivedFileTransfer
      ),
      .init(
        id: 2,
        date: Date(timeIntervalSince1970: 2),
        senderId: myContactId,
        text: "Message 2",
        status: .sent,
        fileTransfer: sentFileTransfer
      ),
    ])

    store.receive(.didFetchMessages(expectedMessages)) {
      $0.messages = expectedMessages
    }

    messagesPublisher.send(completion: .finished)
    fileTransfersPublisher.send(completion: .finished)
  }

  func testStartFailure() {
    let store = TestStore(
      initialState: ChatState(id: .contact("contact-id".data(using: .utf8)!)),
      reducer: chatReducer,
      environment: .unimplemented
    )

    struct Failure: Error {}
    let error = Failure()

    store.environment.mainQueue = .immediate
    store.environment.bgQueue = .immediate
    store.environment.messenger.e2e.get = {
      var e2e: E2E = .unimplemented
      e2e.getContact.run = {
        var contact: XXClient.Contact = .unimplemented(Data())
        contact.getIdFromContact.run = { _ in throw error }
        return contact
      }
      return e2e
    }

    store.send(.start) {
      $0.failure = error.localizedDescription
    }
  }

  func testSend() {
    struct SendMessageParams: Equatable {
      var text: String
      var recipientId: Data
    }
    var didSendMessageWithParams: [SendMessageParams] = []
    var sendMessageCompletion: SendMessage.Completion?

    let store = TestStore(
      initialState: ChatState(id: .contact("contact-id".data(using: .utf8)!)),
      reducer: chatReducer,
      environment: .unimplemented
    )

    store.environment.mainQueue = .immediate
    store.environment.bgQueue = .immediate
    store.environment.sendMessage.run = { text, recipientId, _, completion in
      didSendMessageWithParams.append(.init(text: text, recipientId: recipientId))
      sendMessageCompletion = completion
    }

    store.send(.set(\.$text, "Hello")) {
      $0.text = "Hello"
    }

    store.send(.sendTapped) {
      $0.text = ""
    }

    XCTAssertNoDifference(didSendMessageWithParams, [
      .init(text: "Hello", recipientId: "contact-id".data(using: .utf8)!)
    ])

    sendMessageCompletion?()
  }

  func testSendFailure() {
    var sendMessageOnError: SendMessage.OnError?
    var sendMessageCompletion: SendMessage.Completion?

    let store = TestStore(
      initialState: ChatState(
        id: .contact("contact-id".data(using: .utf8)!),
        text: "Hello"
      ),
      reducer: chatReducer,
      environment: .unimplemented
    )

    store.environment.mainQueue = .immediate
    store.environment.bgQueue = .immediate
    store.environment.sendMessage.run = { _, _, onError, completion in
      sendMessageOnError = onError
      sendMessageCompletion = completion
    }

    store.send(.sendTapped) {
      $0.text = ""
    }

    let error = NSError(domain: "test", code: 123)
    sendMessageOnError?(error)

    store.receive(.sendFailed(error.localizedDescription)) {
      $0.sendFailure = error.localizedDescription
    }

    sendMessageCompletion?()

    store.send(.dismissSendFailureTapped) {
      $0.sendFailure = nil
    }
  }
}
