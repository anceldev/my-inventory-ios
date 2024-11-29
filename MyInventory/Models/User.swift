//
//  User.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import Appwrite

enum ProfileImage: String, Codable, CaseIterable {
    case profileMen1
    case profileMen2
    case profileMen3
    case profileMen4
    case profileMen5
    case profileMen6
    case profileWomen1
    case profileWomen2
    case profileWomen3
    case profileWomen4
    case profileWomen5
    case profileWomen6
}


struct User: Identifiable, Codable {
    var id: String
    var name: String
    var username: String
    var email: String
    var profileImage: ProfileImage?
    var following: [String]
    var inventories: [Inventory]
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, username, email, following, profileImage
    }
    
    init(id: String = Appwrite.ID.unique(), name: String, username: String, email: String, profileImage: ProfileImage? = nil, following: [String] = []) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.following = following
        self.inventories = []
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.profileImage = try container.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
        self.following = try container.decode([String].self, forKey: .following)
        self.inventories = []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.profileImage, forKey: .profileImage)
        try container.encode(self.following, forKey: .following)
    }
}

extension User {
    static var preview = User(
        name: "preview",
        username: "username",
        email: "preview@mail.com",
        profileImage: .profileMen1
    )
}
