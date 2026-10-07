import Foundation

/// Divide um valor entre os membros conforme o percentual de cada um.
/// Os centavos que sobram da divisão vão para os primeiros membros,
/// garantindo que a soma das partes seja sempre igual ao total.
public enum SplitCalculator {
    public static func split(_ total: Money, among members: [MemberDTO]) -> [ShareDTO] {
        guard !members.isEmpty else { return [] }

        let totalPoints = members.reduce(0) { $0 + $1.shareBasisPoints }
        guard totalPoints > 0 else { return [] }

        var shares = members.map { member in
            ShareDTO(
                userID: member.userID,
                amount: Money(cents: total.cents * member.shareBasisPoints / totalPoints)
            )
        }

        var remainder = total.cents - shares.reduce(0) { $0 + $1.amount.cents }
        var index = 0
        while remainder > 0 {
            shares[index % shares.count].amount.cents += 1
            remainder -= 1
            index += 1
        }
        return shares
    }
}
