//
//  Object.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Appwrite
import Foundation

struct Item: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var status: ItemStatus
    var amount: Int
    var boxId: String
    var addedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, description, status, amount, boxId, addedBy
    }
    
    init(name: String, description: String, status: ItemStatus, amount: Int, boxId: String, addedBy: String) {
        self.id = Appwrite.ID.unique()
        self.name = name
        self.description = description
        self.status = status
        self.amount = amount
        self.boxId = boxId
        self.addedBy = addedBy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.status = try container.decode(ItemStatus.self, forKey: .status)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.boxId = try container.decode(String.self, forKey: .boxId)
        self.addedBy = try container.decode(String.self, forKey: .addedBy)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.boxId, forKey: .boxId)
        try container.encode(self.addedBy, forKey: .addedBy)
    }
}

enum ItemStatus: String, Codable {
    case new = "Nuevo"
    case semiNew = "Semi nuevo"
    case used = "Usado"
    case damaged = "Roto"
}

extension Item {
    static var item = Item(
        name: "Tenis ball",
        description: "Green tenis balls",
        status: .new,
        amount: 3,
        boxId: Box.preview.id,
        addedBy: User.preview.id
    )
}
