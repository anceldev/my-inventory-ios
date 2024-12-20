//
//  AccountViewModel.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import Appwrite
import Foundation
import Observation

@Observable
final class AccountViewModel {
    var account: User
    var friends: [User]
    var searchedUsers: [User]
    var errorMessage: String?
    
    init(userId: String) {
        self.account = User(id: userId, name: "", username: "", email: "")
        self.friends = []
        self.searchedUsers = []
        Task {
            await getAccount(for: userId)
//            await getFriends()
        }
    }
    
    
    /// Gets and existing account
    /// - Parameter userId: Account ID
    private func getAccount(for userId: String) async {
        do {
            let user: User = try await AWClient.getModel(collection: .users, id: userId)
            self.account = user
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    /// Get account's friends
    /// - Parameter userId: user account
    /// - Returns: array of ``User`` model
    func getFriends() async {
        do {
            let queries = [Query.equal("$id", value: self.account.following)]
            let friends: [User] = try await AWClient.getModelsWithQuery(collection: .users, queries: queries)
            self.account.friends = friends
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func searchUsers(query: String) async {
        do {
            let queries = [Query.startsWith("username", value: query)]
            let users: [User] = try await AWClient.getModelsWithQuery(collection: .users, queries: queries)
            self.searchedUsers = users
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = errorMessage
        }
    }

    
    func addNewFriend(friendId: String) async -> Bool {
        do {
            var friendsArray = account.following
            friendsArray.append(friendId)
            let jsonData: [String: Any] = [ "following": friendsArray ]
            guard let data = try? JSONSerialization.data(withJSONObject: jsonData),
                  let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "JSON create error", code: -1)
            }
            try await AWClient.updateDocumentData(collection: .users, data: jsonString, docId: account.id)
            self.account.following.append(friendId)
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func updateProfile(newName: String?, newUsername: String?, newAvatar: AvatarImage?) async {
        do {
            var jsonData: [String:Any] = [:]
            if let name = newName {
                jsonData["name"] = name
                self.account.name = name
            }
            if let username = newUsername {
                jsonData["username"] = username
                self.account.username = username
            }
            if let avatar = newAvatar {
                jsonData["avatar"] = avatar.rawValue
                self.account.avatar = avatar
            }
            if jsonData.count == 0 { return }
            guard let data = try? JSONSerialization.data(withJSONObject: jsonData),
                  let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "JSON Create Error", code: -1)
            }
            try await AWClient.updateDocumentData(collection: .users, data: jsonString, docId: account.id)
            
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
}
