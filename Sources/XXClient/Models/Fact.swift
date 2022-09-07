import Foundation

public struct Fact: Equatable {
  public init(
    fact: String,
    type: FactType
  ) {
    self.fact = fact
    self.type = type
  }

  public var fact: String
  public var type: FactType
}

extension Fact: Codable {
  enum CodingKeys: String, CodingKey {
    case fact = "Fact"
    case type = "T"
  }

  public static func decode(_ data: Data) throws -> Self {
    try JSONDecoder().decode(Self.self, from: data)
  }

  public func encode() throws -> Data {
    try JSONEncoder().encode(self)
  }
}

extension Array where Element == Fact {
  public static func decode(_ data: Data) throws -> Self {
    if let string = String(data: data, encoding: .utf8), string == "null" {
      return []
    }
    return try JSONDecoder().decode(Self.self, from: data)
  }

  public func encode() throws -> Data {
    if isEmpty {
      return "null".data(using: .utf8)!
    }
    return try JSONEncoder().encode(self)
  }
}

extension Array where Element == Fact {
  public func get(_ type: FactType) -> Fact? {
    first(where: { $0.type == type })
  }

  public mutating func set(_ type: FactType, _ value: String?) {
    removeAll(where: { $0.type == type })
    if let value = value {
      append(Fact(fact: value, type: type))
      sort(by: { $0.type < $1.type })
    }
  }
}
