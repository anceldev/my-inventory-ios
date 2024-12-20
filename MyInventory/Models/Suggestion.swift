//
//  Suggestion.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import Appwrite
import Foundation
import SwiftUI

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
        case implemented
        case approved
        case review
        
        var name: String {
            switch self {
            case .approved:     return "Aprobado"
            case .implemented:  return "Implementado"
            case .review:   return "En revisión"
            }
        }
        
        var foreground: Color {
            switch self {
            case .approved:     return Color.blueDarker
            case .implemented:  return Color.greenDarker
            case .review:       return Color.yellowDarker
            }
        }
        var background: Color {
            switch self {
            case .approved:     return .blueLight
            case .implemented:  return .greenLight
            case .review:       return .yellowLight
            }
        }
    }
    
    static var previewApproved: Suggestion = .init(userId: "", title: "First", content: "Content of the first suggestion", status: .approved)
    static var previewReview: Suggestion = .init(userId: "", title: "Second one", content: "This is the second suggestion added.This is the second suggestion added. This is the second suggestion added. This is the second suggestion added. This is the second suggestion added. This is the second suggestion added. This is the second suggestion added. This is the second suggestion added", status: .review)
    static var previewImplemented: Suggestion = .init(userId: "", title: "third", content: "Another suggestion made", status: .implemented)
}
