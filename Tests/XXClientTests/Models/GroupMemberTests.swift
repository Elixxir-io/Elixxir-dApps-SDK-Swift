import CustomDump
import XCTest
@testable import XXClient

final class GroupMemberTests: XCTestCase {
  func testCoding() throws {
    let idB64 = "SGVsbG8sIFdvcmxkISBHcm91cCBNZW1iZXIgVGVzdCBJRA=="
    let dhKeyValue = "1759426033802606996617132861414734059978289057332806031357800676138355264622676606691435603603751978195460163638145821347601916259127578968570412642641025630452893097179266022832268525346700655861033031712000288680395716922501450233258587788020541937373196899001184700899008948530359980753630443486308876999029238453979779103124291315202352475056237021681172884599194016245219278368648568458514708567045834427853469072638665888791358582182353417065794210125797368093469194927663862565508608719835557592421245749381164023134450699040591219966988201315627676532245052123725278573237006510683695959381015415110970848376498637637944431576313526294020390694483472829278364602405292767170719547347485307956614210210673321959886410245334772057212077704024337636501108566655549055129066343309591274727538343075929837698653965640646190405582788894021694347212874155979958144038307500444865955516612526623220973497735316081265793063949"
    let dhKeyFingerprint: UInt64 = 15989433043166758754
    let jsonString = """
    {
      "ID": "\(idB64)",
      "DhKey": {
        "Value": \(dhKeyValue),
        "Fingerprint": \(dhKeyFingerprint)
      }
    }
    """
    let jsonData = jsonString.data(using: .utf8)!
    let model = try GroupMember.decode(jsonData)

    XCTAssertNoDifference(model, GroupMember(
      id: Data(base64Encoded: idB64)!,
      dhKey: DHKey(
        value: dhKeyValue,
        fingerprint: dhKeyFingerprint
      )
    ))

    let encodedModel = try model.encode()
    let encodedModelString = String(data: encodedModel, encoding: .utf8)!
    XCTAssertNoDifference(
      encodedModelString,
      """
      {"ID":"\(idB64)","DhKey":{"Value":\(dhKeyValue),"Fingerprint":\(dhKeyFingerprint)}}
      """
    )

    let jsonArrayString = "[\(jsonString)]"
    let jsonArrayData = jsonArrayString.data(using: .utf8)!
    let decodedModels = try [GroupMember].decode(jsonArrayData)

    XCTAssertNoDifference(decodedModels, [model])

    let encodedModels = try decodedModels.encode()
    let encodedModelsString = String(data: encodedModels, encoding: .utf8)!

    XCTAssertNoDifference(
      encodedModelsString,
      "[\(encodedModelString)]"
    )
  }
}
