import Foundation

/// Valor monetário guardado em centavos para evitar erros de arredondamento.
/// R$ 1.234,56 → Money(cents: 123456)
public struct Money: Hashable, Sendable, Comparable {
    public var cents: Int

    public init(cents: Int) {
        self.cents = cents
    }

    public static let zero = Money(cents: 0)

    public static func + (lhs: Money, rhs: Money) -> Money {
        Money(cents: lhs.cents + rhs.cents)
    }

    public static func - (lhs: Money, rhs: Money) -> Money {
        Money(cents: lhs.cents - rhs.cents)
    }

    public static func < (lhs: Money, rhs: Money) -> Bool {
        lhs.cents < rhs.cents
    }
}

// No JSON da API, o valor vai como número inteiro: "amount": 123456
extension Money: Codable {
    public init(from decoder: Decoder) throws {
        cents = try decoder.singleValueContainer().decode(Int.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(cents)
    }
}
