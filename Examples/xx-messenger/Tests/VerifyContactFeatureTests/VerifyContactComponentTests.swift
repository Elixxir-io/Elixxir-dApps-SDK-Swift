import ComposableArchitecture
import CustomDump
import XCTest
import XXClient
import XXModels
@testable import VerifyContactFeature

final class VerifyContactComponentTests: XCTestCase {
  func testVerify() {
    var contact = XXClient.Contact.unimplemented("contact-data".data(using: .utf8)!)
    let contactId = "contact-id".data(using: .utf8)!
    contact.getIdFromContact.run = { _ in contactId }

    let store = TestStore(
      initialState: VerifyContactComponent.State(
        contact: contact
      ),
      reducer: VerifyContactComponent()
    )

    var didVerifyContact: [XXClient.Contact] = []
    var didBulkUpdateContactsWithQuery: [XXModels.Contact.Query] = []
    var didBulkUpdateContactsWithAssignments: [XXModels.Contact.Assignments] = []

    store.dependencies.app.mainQueue = .immediate
    store.dependencies.app.bgQueue = .immediate
    store.dependencies.app.messenger.verifyContact.run = { contact in
      didVerifyContact.append(contact)
      return true
    }
    store.dependencies.app.dbManager.getDB.run = {
      var db: Database = .unimplemented
      db.bulkUpdateContacts.run = { query, assignments in
        didBulkUpdateContactsWithQuery.append(query)
        didBulkUpdateContactsWithAssignments.append(assignments)
        return 0
      }
      return db
    }

    store.send(.verifyTapped) {
      $0.isVerifying = true
      $0.result = nil
    }

    XCTAssertNoDifference(didVerifyContact, [contact])
    XCTAssertNoDifference(didBulkUpdateContactsWithQuery, [
      .init(id: [contactId]),
      .init(id: [contactId]),
    ])
    XCTAssertNoDifference(didBulkUpdateContactsWithAssignments, [
      .init(authStatus: .verificationInProgress),
      .init(authStatus: .verified)
    ])

    store.receive(.didVerify(.success(true))) {
      $0.isVerifying = false
      $0.result = .success(true)
    }
  }

  func testVerifyNotVerified() {
    var contact = XXClient.Contact.unimplemented("contact-data".data(using: .utf8)!)
    let contactId = "contact-id".data(using: .utf8)!
    contact.getIdFromContact.run = { _ in contactId }

    let store = TestStore(
      initialState: VerifyContactComponent.State(
        contact: contact
      ),
      reducer: VerifyContactComponent()
    )

    var didVerifyContact: [XXClient.Contact] = []
    var didBulkUpdateContactsWithQuery: [XXModels.Contact.Query] = []
    var didBulkUpdateContactsWithAssignments: [XXModels.Contact.Assignments] = []

    store.dependencies.app.mainQueue = .immediate
    store.dependencies.app.bgQueue = .immediate
    store.dependencies.app.messenger.verifyContact.run = { contact in
      didVerifyContact.append(contact)
      return false
    }
    store.dependencies.app.dbManager.getDB.run = {
      var db: Database = .unimplemented
      db.bulkUpdateContacts.run = { query, assignments in
        didBulkUpdateContactsWithQuery.append(query)
        didBulkUpdateContactsWithAssignments.append(assignments)
        return 0
      }
      return db
    }

    store.send(.verifyTapped) {
      $0.isVerifying = true
      $0.result = nil
    }

    XCTAssertNoDifference(didVerifyContact, [contact])
    XCTAssertNoDifference(didBulkUpdateContactsWithQuery, [
      .init(id: [contactId]),
      .init(id: [contactId]),
    ])
    XCTAssertNoDifference(didBulkUpdateContactsWithAssignments, [
      .init(authStatus: .verificationInProgress),
      .init(authStatus: .verificationFailed),
    ])

    store.receive(.didVerify(.success(false))) {
      $0.isVerifying = false
      $0.result = .success(false)
    }
  }

  func testVerifyFailure() {
    var contact = XXClient.Contact.unimplemented("contact-data".data(using: .utf8)!)
    let contactId = "contact-id".data(using: .utf8)!
    contact.getIdFromContact.run = { _ in contactId }

    let store = TestStore(
      initialState: VerifyContactComponent.State(
        contact: contact
      ),
      reducer: VerifyContactComponent()
    )

    struct Failure: Error {}
    let error = Failure()

    var didBulkUpdateContactsWithQuery: [XXModels.Contact.Query] = []
    var didBulkUpdateContactsWithAssignments: [XXModels.Contact.Assignments] = []

    store.dependencies.app.mainQueue = .immediate
    store.dependencies.app.bgQueue = .immediate
    store.dependencies.app.messenger.verifyContact.run = { _ in throw error }
    store.dependencies.app.dbManager.getDB.run = {
      var db: Database = .unimplemented
      db.bulkUpdateContacts.run = { query, assignments in
        didBulkUpdateContactsWithQuery.append(query)
        didBulkUpdateContactsWithAssignments.append(assignments)
        return 0
      }
      return db
    }

    store.send(.verifyTapped) {
      $0.isVerifying = true
      $0.result = nil
    }

    XCTAssertNoDifference(didBulkUpdateContactsWithQuery, [
      .init(id: [contactId]),
      .init(id: [contactId]),
    ])
    XCTAssertNoDifference(didBulkUpdateContactsWithAssignments, [
      .init(authStatus: .verificationInProgress),
      .init(authStatus: .verificationFailed),
    ])

    store.receive(.didVerify(.failure(error.localizedDescription))) {
      $0.isVerifying = false
      $0.result = .failure(error.localizedDescription)
    }
  }
}
