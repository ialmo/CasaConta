import Fluent

struct CreateInitialSchema: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string)
            .field("apple_user_id", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "apple_user_id")
            .create()

        try await database.schema("groups")
            .id()
            .field("name", .string, .required)
            .field("invite_code", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "invite_code")
            .create()

        try await database.schema("members")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("group_id", .uuid, .required, .references("groups", "id", onDelete: .cascade))
            .field("share_basis_points", .int, .required)
            .unique(on: "user_id", "group_id")
            .create()

        try await database.schema("recurring_bills")
            .id()
            .field("group_id", .uuid, .required, .references("groups", "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("amount_cents", .int, .required)
            .field("due_day", .int, .required)
            .field("category", .string, .required)
            .field("installment_current", .int)
            .field("installment_total", .int)
            .field("created_at", .datetime)
            .create()

        try await database.schema("entries")
            .id()
            .field("group_id", .uuid, .required, .references("groups", "id", onDelete: .cascade))
            .field("description", .string, .required)
            .field("amount_cents", .int, .required)
            .field("date", .datetime, .required)
            .field("category", .string, .required)
            .field("status", .string, .required)
            .field("paid_by_user_id", .uuid, .references("users", "id", onDelete: .setNull))
            .field("recurring_bill_id", .uuid, .references("recurring_bills", "id", onDelete: .setNull))
            .field("created_at", .datetime)
            .create()

        try await database.schema("shares")
            .id()
            .field("entry_id", .uuid, .required, .references("entries", "id", onDelete: .cascade))
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("amount_cents", .int, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        for table in ["shares", "entries", "recurring_bills", "members", "groups", "users"] {
            try await database.schema(table).delete()
        }
    }
}
