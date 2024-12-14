//
//  RootView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct RootView: View {
    
    
    enum Tabs: String, Identifiable {
        case profile
        case add
        case inventories
        
        var id: String {
            self.rawValue
        }
    }
    
    @State private var selectedTab: Tabs = .inventories
    
    init() {
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().unselectedItemTintColor = UIColor(.neutral300)
//        UITabBar.appearance().tintColor = UIColor(.text)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InventoriesListView()
                .tabItem {
                    Label("Invetories", systemImage: selectedTab == .inventories ? "shippingbox.fill" : "shippingbox")
                }
                .tag(Tabs.inventories)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
                }
                .tag(Tabs.profile)
        }
        .tint(.neutral600)
        .animation(.easeOut, value: selectedTab)
        .transition(.slide)
    }
}

#Preview {
    NavigationStack {
        RootView()
            .environment(AuthViewModel())
    }
}
