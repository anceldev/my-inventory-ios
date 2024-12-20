//
//  Suggestion.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import Appwrite
import Foundation

struct Suggestion: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var content: String
    var status: Status
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case userId, title, content, status
    }
    
    init(id: String = Appwrite.ID.unique(), userId: String, title: String, content: String, status: Status = .review) {
        self.id = id
        self.userId = userId
        self.title = title
        self.content = content
        self.status = status
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.status, forKey: .status)
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.status = try container.decode(Status.self, forKey: .status)
    }
}

extension Suggestion {
    enum Status: String, Codable {
        case approved, implemented, review
    }
}
