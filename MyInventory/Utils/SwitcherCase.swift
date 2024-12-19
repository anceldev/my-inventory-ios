//
//  SwitcherCase.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import Foundation

protocol SwitcherCase {
    var title: String { get }
    var count: Int { get }
}

enum InventoriesLists: CaseIterable, SwitcherCase, Hashable {
    case mine
    case shared
    
    static var counts: [InventoriesLists: Int] = [
        .mine: 0,
        .shared: 0
    ]
    
    var title: String {
        switch self {
        case .mine: "Míos"
        case .shared: "Compartidos"
        }
    }
    
    var count: Int {
        get {
            return InventoriesLists.counts[self] ?? 0
        }
        set {
            InventoriesLists.counts[self] = newValue
        }
    }
}


enum FriendsLists: CaseIterable, SwitcherCase, Hashable {
    case myFriends
    case searchFriends
    
    static var counts: [FriendsLists: Int] = [
        .myFriends: 0,
        .searchFriends: 0
    ]
    
    var title: String {
        switch self {
        case .myFriends: "Mis amigos"
        case .searchFriends: "Buscar"
        }
    }
    
    var count: Int {
        get {
            return FriendsLists.counts[self] ?? 0
        }
        set {
            FriendsLists.counts[self] = newValue
        }
    }
}
