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

enum InventoryType: CaseIterable, SwitcherCase, Hashable {
    case mine
    case shared
    
    static var counts: [InventoryType: Int] = [
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
            return InventoryType.counts[self] ?? 0
        }
        set {
            InventoryType.counts[self] = newValue
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

enum Improvement: CaseIterable, SwitcherCase, Hashable {
    case approved
    case implemented
    case review
    
    static var counts: [Improvement: Int] = [
        .approved: 0,
        .implemented: 0,
        .review: 0,
    ]
    var title: String {
        switch self {
        case .approved: "Aprobado"
        case .implemented: "Implementado"
        case .review: "En revisión"
        }
    }
    var count: Int {
        get {
//            return Improvement.counts[self] ?? 0
            return Improvement.counts[self]!
        }
        set {
            Improvement.counts[self] = newValue
        }
    }
}
