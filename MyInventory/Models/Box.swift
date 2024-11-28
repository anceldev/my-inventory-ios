//
//  Box.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Appwrite
import Foundation

struct Box: Codable, Identifiable {
    var id: String
    var name: String
    var inventoryId: String
    var createdBy: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, inventoryId, createdBy
    }
    
    init(name: String, inventoryId: String, createdBy: String? = nil) {
        self.id = Appwrite.ID.unique()
        self.name = name
        self.inventoryId = inventoryId
        self.createdBy = createdBy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.inventoryId = try container.decode(String.self, forKey: .inventoryId)
        self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.inventoryId, forKey: .inventoryId)
        try container.encode(self.createdBy, forKey: .createdBy)
    }
}

extension Box {
    static var preview = Box(
        name: "Balls",
        inventoryId: Inventory.preview.id,
        createdBy: User.preview.id
    )
}

