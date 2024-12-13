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
    var description: String?
    var status: ItemStatus
    var amount: Int
    var boxId: String?
    var addedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, description, status, amount, boxId, addedBy
    }
    
    init(name: String, description: String? = nil, status: ItemStatus, amount: Int, boxId: String? = nil, addedBy: String) {
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
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.status = try container.decode(ItemStatus.self, forKey: .status)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.boxId = try container.decodeIfPresent(String.self, forKey: .boxId)
        self.addedBy = try container.decode(String.self, forKey: .addedBy)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.amount, forKey: .amount)
        try container.encodeIfPresent(self.boxId, forKey: .boxId)
        try container.encode(self.addedBy, forKey: .addedBy)
    }
}

enum ItemStatus: String, Codable {
    case new = "Nuevo"
    case used = "Usado"
    case damaged = "Roto"
}

extension Item {
    static var item = Item(
        name: "Pelotas de tenis",
        description: "Pelotas de tenis verdes",
        status: .new,
        amount: 3,
        boxId: Box.preview1.id,
        addedBy: User.previewJuan.id
    )
}
