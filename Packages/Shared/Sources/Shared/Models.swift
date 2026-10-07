import Foundation

// MARK: - Enums

public enum ExpenseCategory: String, Codable, CaseIterable, Sendable {
    case housing, groceries, transport, utilities, leisure, health, other
}

public enum EntryStatus: String, Codable, Sendable {
    case pending, paid
}

// MARK: - Usuário e grupo

public struct UserDTO: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public var name: String
    public var email: String?

    public init(id: UUID, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
    }
}

public struct MemberDTO: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let userID: UUID
    public var name: String
    /// Percentual em pontos-base: 5000 = 50%, 10000 = 100%
    public var shareBasisPoints: Int

    public init(id: UUID, userID: UUID, name: String, shareBasisPoints: Int) {
        self.id = id
        self.userID = userID
        self.name = name
        self.shareBasisPoints = shareBasisPoints
    }
}

public struct GroupDTO: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public var name: String
    public var inviteCode: String
    public var members: [MemberDTO]

    public init(id: UUID, name: String, inviteCode: String, members: [MemberDTO]) {
        self.id = id
        self.name = name
        self.inviteCode = inviteCode
        self.members = members
    }
}

// MARK: - Contas fixas

public struct Installment: Codable, Hashable, Sendable {
    public var current: Int
    public var total: Int

    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }
}

public struct RecurringBillDTO: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let groupID: UUID
    public var name: String
    public var amount: Money
    /// Dia do mês em que vence (1...31)
    public var dueDay: Int
    public var category: ExpenseCategory
    /// Preenchido só para contas parceladas, como o financiamento
    public var installment: Installment?

    public init(id: UUID, groupID: UUID, name: String, amount: Money,
                dueDay: Int, category: ExpenseCategory, installment: Installment? = nil) {
        self.id = id
        self.groupID = groupID
        self.name = name
        self.amount = amount
        self.dueDay = dueDay
        self.category = category
        self.installment = installment
    }
}

// MARK: - Lançamentos e divisão

public struct ShareDTO: Codable, Hashable, Sendable {
    public let userID: UUID
    public var amount: Money

    public init(userID: UUID, amount: Money) {
        self.userID = userID
        self.amount = amount
    }
}

public struct EntryDTO: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let groupID: UUID
    public var description: String
    public var amount: Money
    public var date: Date
    public var category: ExpenseCategory
    public var status: EntryStatus
    public var paidByUserID: UUID?
    /// Preenchido quando o lançamento vem de uma conta fixa
    public var recurringBillID: UUID?
    public var shares: [ShareDTO]

    public init(id: UUID, groupID: UUID, description: String, amount: Money,
                date: Date, category: ExpenseCategory, status: EntryStatus,
                paidByUserID: UUID? = nil, recurringBillID: UUID? = nil,
                shares: [ShareDTO]) {
        self.id = id
        self.groupID = groupID
        self.description = description
        self.amount = amount
        self.date = date
        self.category = category
        self.status = status
        self.paidByUserID = paidByUserID
        self.recurringBillID = recurringBillID
        self.shares = shares
    }
}
