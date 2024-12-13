//
//  Inventory.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Appwrite
import Foundation

struct Inventory: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var ownerId: String
    var sharedWith: [String]
    var users: [User]
    var boxes: [Box]
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, description, ownerId, sharedWith
    }
    
    init(name: String, description: String, owenerId: String, sharedWith: [String] = [], users: [User] = [], boxes: [Box] = []) {
        self.id = Appwrite.ID.unique()
        self.name = name
        self.description = description
        self.ownerId = owenerId
        self.sharedWith = sharedWith
        self.users = users
        self.boxes = boxes
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.sharedWith = try container.decode([String].self, forKey: .sharedWith)
        self.users = []
        self.boxes = []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.ownerId, forKey: .ownerId)
        try container.encode(self.sharedWith, forKey: .sharedWith)
    }
    
    // Add hash(into:) function for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Add static equals function for Hashable conformance
    static func == (lhs: Inventory, rhs: Inventory) -> Bool {
        lhs.id == rhs.id
    }
}

extension Inventory {
    static var preview = Inventory(
        name: "Material Juegos",
        description: "Materiales para realizar juegos",
        owenerId: User.previewJuan.id,
        users: [User.previewPedro, User.previewMari]
//        boxes: [Box.preview1, Box.preview2, Box.preview3]
    )
    static var inventoriesPreview: [Inventory] = [Inventory.preview]
}
