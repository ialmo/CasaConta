import Foundation
import Testing
@testable import Shared

@Suite("SplitCalculator")
struct SplitCalculatorTests {
    let ialmo = UUID()
    let esposa = UUID()

    func members(_ a: Int, _ b: Int) -> [MemberDTO] {
        [
            MemberDTO(id: UUID(), userID: ialmo, name: "Ialmo", shareBasisPoints: a),
            MemberDTO(id: UUID(), userID: esposa, name: "Esposa", shareBasisPoints: b)
        ]
    }

    @Test("Divide 50/50 e o centavo ímpar vai para o primeiro")
    func fiftyFifty() {
        let shares = SplitCalculator.split(Money(cents: 1001), among: members(5000, 5000))
        #expect(shares.map(\.amount.cents) == [501, 500])
    }

    @Test("Divide 70/30 sem perder centavos")
    func seventyThirty() {
        let shares = SplitCalculator.split(Money(cents: 333), among: members(7000, 3000))
        #expect(shares.map(\.amount.cents) == [234, 99])
        #expect(shares.reduce(0) { $0 + $1.amount.cents } == 333)
    }

    @Test("Sem membros, retorna vazio")
    func noMembers() {
        #expect(SplitCalculator.split(Money(cents: 100), among: []).isEmpty)
    }
}
