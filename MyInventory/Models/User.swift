//
//  User.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import Appwrite

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, email
    }
    
    init(name: String, email: String) {
        self.id = Appwrite.ID.unique()
        self.name = name
        self.email = email
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.email, forKey: .email)
    }
}

extension User {
    static var preview = User(
        name: "preview",
        email: "preview@mail.com"
    )
}
