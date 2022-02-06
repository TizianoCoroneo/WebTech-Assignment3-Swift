import Vapor
import Fluent

func routes(_ app: Application) throws {

    app.get("products") { req async throws in
        try await Product.query(on: req.db).all()
    }

    app.get("products", ":id") { req async throws -> Product in
        guard
            let idString = req.parameters.get("id"),
            let id = Int(idString)
        else { throw Abort(.badRequest) }

        guard let product = try await Product.query(on: req.db)
            .filter(\.$id == id)
            .first()
        else { throw Abort(.notFound) }

        return product
    }

    app.put("products", ":id") { req async throws -> Product in
        let newProduct = try req.content.decode(Product.self)

        guard
            let idString = req.parameters.get("id"),
            let id = Int(idString)
        else { throw Abort(.badRequest) }

        guard let product = try await Product.query(on: req.db)
            .filter(\.$id == id)
            .first()
        else { throw Abort(.notFound) }

        product.brand = newProduct.brand
        product.model = newProduct.model
        product.os = newProduct.os
        product.screensize = newProduct.screensize
        product.image = newProduct.image

        try await product.update(on: req.db)
        return product
    }

    app.post("products") { req async throws -> Product in
        let product = try req.content.decode(Product.self)
        try await product.create(on: req.db)
        return product
    }

    app.delete("products", ":id") { req async throws -> [String: String] in
        guard
            let idString = req.parameters.get("id"),
            let id = Int(idString)
        else { throw Abort(.badRequest) }

        try await Product.query(on: req.db)
            .filter(\.$id == id)
            .delete()

        return [
            "message": "Successful deletion."
        ]
    }

    app.post("products", "reset") { req async throws -> [String: String] in
        try await Product.query(on: req.db)
            .delete()

        return [
            "message": "Successful reset."
        ]
    }
}
