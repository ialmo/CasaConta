import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "CasaConta API rodando"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
}
