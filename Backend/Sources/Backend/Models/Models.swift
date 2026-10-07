import Fluent
import Foundation
import Shared

final class User: Model, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @OptionalField(key: "email") var email: String?
    @Field(key: "apple_user_id") var appleUserID: String
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, email: String?, appleUserID: String) {
        self.id = id
        self.name = name
        self.email = email
        self.appleUserID = appleUserID
    }
}

final class Group: Model, @unchecked Sendable {
    static let schema = "groups"

    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "invite_code") var inviteCode: String
    @Children(for: \.$group) var members: [Member]
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, inviteCode: String) {
        self.id = id
        self.name = name
        self.inviteCode = inviteCode
    }
}

final class Member: Model, @unchecked Sendable {
    static let schema = "members"

    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Parent(key: "group_id") var group: Group
    @Field(key: "share_basis_points") var shareBasisPoints: Int

    init() {}

    init(id: UUID? = nil, userID: UUID, groupID: UUID, shareBasisPoints: Int) {
        self.id = id
        self.$user.id = userID
        self.$group.id = groupID
        self.shareBasisPoints = shareBasisPoints
    }
}

final class RecurringBill: Model, @unchecked Sendable {
    static let schema = "recurring_bills"

    @ID(key: .id) var id: UUID?
    @Parent(key: "group_id") var group: Group
    @Field(key: "name") var name: String
    @Field(key: "amount_cents") var amountCents: Int
    @Field(key: "due_day") var dueDay: Int
    @Field(key: "category") var category: ExpenseCategory
    @OptionalField(key: "installment_current") var installmentCurrent: Int?
    @OptionalField(key: "installment_total") var installmentTotal: Int?
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() {}
}

final class Entry: Model, @unchecked Sendable {
    static let schema = "entries"

    @ID(key: .id) var id: UUID?
    @Parent(key: "group_id") var group: Group
    @Field(key: "description") var description: String
    @Field(key: "amount_cents") var amountCents: Int
    @Field(key: "date") var date: Date
    @Field(key: "category") var category: ExpenseCategory
    @Field(key: "status") var status: EntryStatus
    @OptionalParent(key: "paid_by_user_id") var paidBy: User?
    @OptionalParent(key: "recurring_bill_id") var recurringBill: RecurringBill?
    @Children(for: \.$entry) var shares: [Share]
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() {}
}

final class Share: Model, @unchecked Sendable {
    static let schema = "shares"

    @ID(key: .id) var id: UUID?
    @Parent(key: "entry_id") var entry: Entry
    @Parent(key: "user_id") var user: User
    @Field(key: "amount_cents") var amountCents: Int

    init() {}
}
