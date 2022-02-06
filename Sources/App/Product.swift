//
//  Product.swift
//  
//
//  Created by Tiziano Coroneo on 06/02/2022.
//

import Foundation
import Fluent
import Vapor

final class Product: Model, Content {
    static let schema = "phones"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "brand")
    var brand: String

    @Field(key: "model")
    var model: String

    @Field(key: "os")
    var os: String

    @Field(key: "screensize")
    var screensize: Int

    @Field(key: "image")
    var image: String

    init() {}

    init(
        id: Int? = nil,
        brand: String,
        model: String,
        os: String,
        screensize: Int,
        image: String
    ) {
        self.id = id
        self.brand = brand
        self.model = model
        self.os = os
        self.screensize = screensize
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case model
        case os
        case screensize
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try? container.decode(Int?.self, forKey: .id)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.model = try container.decode(String.self, forKey: .model)
        self.os = try container.decode(String.self, forKey: .os)
        self.image = try container.decode(String.self, forKey: .image)

        do {
            self.screensize = try container.decode(Int.self, forKey: .screensize)
        } catch {
            let screensizeString = try container.decode(String.self, forKey: .screensize)
            guard let screensize = Int(screensizeString) else { throw Abort(.badRequest) }
            self.screensize = screensize
        }
    }
}
