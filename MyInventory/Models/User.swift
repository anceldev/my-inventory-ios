//
//  User.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import Appwrite

enum AvatarImage: String, Codable, CaseIterable {
    case avatarMen1
    case avatarMen2
    case avatarMen3
    case avatarMen4
    case avatarMen5
    case avatarMen6
    case avatarWomen1
    case avatarWomen2
    case avatarWomen3
    case avatarWomen4
    case avatarWomen5
    case avatarWomen6
    
    case avatarDefault
}


struct User: Identifiable, Codable {
    var id: String
    var name: String
    var username: String
    var email: String
    var avatar: AvatarImage
    var following: [String]
    var inventories: [Inventory]
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, username, email, following, avatar
    }
    
    init(id: String = Appwrite.ID.unique(), name: String, username: String, email: String, avatar: AvatarImage = .avatarDefault, following: [String] = []) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.avatar = avatar
        self.following = following
        self.inventories = []
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.avatar = try container.decode(AvatarImage.self, forKey: .avatar)
        self.following = try container.decode([String].self, forKey: .following)
        self.inventories = []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.avatar, forKey: .avatar)
        try container.encode(self.following, forKey: .following)
    }
}

extension User {
    static var preview = User(
        name: "Ancel Guarayo",
        username: "ancelote",
        email: "ancel@mail.com",
        avatar: .avatarMen1
    )
    
    static var previewJuan = User(
        name: "Juan",
        username: "juanito",
        email: "juan@mail.com",
        avatar: .avatarMen2
    )
    static var previewPedro = User(
        name: "pedro",
        username: "pedrito",
        email: "pedro@mail.com",
        avatar: .avatarMen5
    )
    static var previewMari = User(
        name: "Mari",
        username: "marin",
        email: "mari@mail.com",
        avatar: .avatarWomen1
    )
}
