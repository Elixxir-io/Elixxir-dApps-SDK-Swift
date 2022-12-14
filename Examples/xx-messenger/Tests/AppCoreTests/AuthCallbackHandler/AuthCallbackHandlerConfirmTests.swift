import CustomDump
import XCTest
import XXModels
import XXClient
@testable import AppCore

final class AuthCallbackHandlerConfirmTests: XCTestCase {
  func testConfirm() throws {
    var didFetchContacts: [XXModels.Contact.Query] = []
    var didSaveContact: [XXModels.Contact] = []

    let dbContact = XXModels.Contact(
      id: "id".data(using: .utf8)!,
      authStatus: .requested
    )
    let confirm = AuthCallbackHandlerConfirm.live(
      db: .init {
        var db: Database = .unimplemented
        db.fetchContacts.run = { query in
          didFetchContacts.append(query)
          return [dbContact]
        }
        db.saveContact.run = { contact in
          didSaveContact.append(contact)
          return contact
        }
        return db
      }
    )
    var xxContact = XXClient.Contact.unimplemented("contact".data(using: .utf8)!)
    xxContact.getIdFromContact.run = { _ in "id".data(using: .utf8)! }

    try confirm(xxContact)

    XCTAssertNoDifference(didFetchContacts, [.init(id: ["id".data(using: .utf8)!])])
    var expectedSavedContact = dbContact
    expectedSavedContact.authStatus = .friend
    XCTAssertNoDifference(didSaveContact, [expectedSavedContact])
  }

  func testConfirmWhenContactNotInDatabase() throws {
    let confirm = AuthCallbackHandlerConfirm.live(
      db: .init {
        var db: Database = .unimplemented
        db.fetchContacts.run = { _ in [] }
        return db
      }
    )
    var contact = XXClient.Contact.unimplemented("contact".data(using: .utf8)!)
    contact.getIdFromContact.run = { _ in "id".data(using: .utf8)! }

    try confirm(contact)
  }
}
