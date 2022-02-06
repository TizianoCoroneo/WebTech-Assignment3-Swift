import Vapor
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {

    app.http.server.configuration.port = 3000

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("phones.db")), as: .sqlite)

    // register routes
    try routes(app)
}
