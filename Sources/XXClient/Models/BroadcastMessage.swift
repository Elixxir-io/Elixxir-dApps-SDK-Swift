import Foundation

public struct BroadcastMessage: Equatable {
  public init(
    roundId: Int,
    ephId: [Int],
    payload: Data
  ) {
    self.roundId = roundId
    self.ephId = ephId
    self.payload = payload
  }

  public var roundId: Int
  public var ephId: [Int]
  public var payload: Data
}

extension BroadcastMessage: Codable {
  enum CodingKeys: String, CodingKey {
    case roundId = "RoundID"
    case ephId = "EphID"
    case payload = "Payload"
  }

  public static func decode(_ data: Data) throws -> Self {
    try JSONDecoder().decode(Self.self, from: data)
  }

  public func encode() throws -> Data {
    try JSONEncoder().encode(self)
  }
}