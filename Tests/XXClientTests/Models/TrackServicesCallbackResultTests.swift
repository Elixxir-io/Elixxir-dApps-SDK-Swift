import CustomDump
import XCTest
@testable import XXClient

final class TrackServicesCallbackResultTests: XCTestCase {
  func testCoding() throws {
    let idB64 = "AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD"
    let serviceIdentifierB64 = "AQID"
    let serviceTag = "TestTag 2"
    let serviceMetadataB64 = "BAUG"
    let jsonString = """
    {
      "Id": "\(idB64)",
      "Services": [
        {
          "Identifier": "\(serviceIdentifierB64)",
          "Tag": "\(serviceTag)",
          "Metadata": "\(serviceMetadataB64)"
        }
      ]
    }
    """
    let jsonData = jsonString.data(using: .utf8)!
    let model = try TrackServicesCallbackResult.decode(jsonData)

    XCTAssertNoDifference(model, TrackServicesCallbackResult(
      id: Data(base64Encoded: idB64)!,
      services: [
        MessageService(
          identifier: Data(base64Encoded: serviceIdentifierB64)!,
          tag: serviceTag,
          metadata: Data(base64Encoded: serviceMetadataB64)!
        )
      ]
    ))

    let encodedModel = try model.encode()
    let decodedModel = try TrackServicesCallbackResult.decode(encodedModel)

    XCTAssertNoDifference(decodedModel, model)
  }

  func testCodingArray() throws {
    let models = [
      TrackServicesCallbackResult(
        id: "id1".data(using: .utf8)!,
        services: [
          MessageService(
            identifier: "service1-id".data(using: .utf8)!,
            tag: "service1-tag",
            metadata: "service1-metadata".data(using: .utf8)!
          ),
        ]
      ),
      TrackServicesCallbackResult(
        id: "id2".data(using: .utf8)!,
        services: [
          MessageService(
            identifier: "service2-id".data(using: .utf8)!,
            tag: "service2-tag",
            metadata: "service2-metadata".data(using: .utf8)!
          ),
          MessageService(
            identifier: "service3-id".data(using: .utf8)!,
            tag: "service3-tag",
            metadata: "service3-metadata".data(using: .utf8)!
          ),
        ]
      ),
    ]

    let encodedModels = try models.encode()
    let decodedModels = try [TrackServicesCallbackResult].decode(encodedModels)

    XCTAssertNoDifference(models, decodedModels)
  }
}
