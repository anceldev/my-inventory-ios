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
    @State var accountVM: AccountViewModel
    @State private var selectedTab: Tabs = .inventories
    
    init(for userId: String) {
        self._accountVM = State(initialValue: AccountViewModel(userId: userId))
        
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().unselectedItemTintColor = UIColor(.neutral300)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InventoriesListView(for: accountVM.account)
                .tabItem {
                    Label("Invetarios", systemImage: selectedTab == .inventories ? "shippingbox.fill" : "shippingbox")
                        .labelStyle(.iconOnly)
                }
                .tag(Tabs.inventories)
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: selectedTab == .profile ? "person.fill" : "person")
                        .labelStyle(.iconOnly)
                }
                .tag(Tabs.profile)
        }
        .tint(.neutral600)
        .animation(.easeOut, value: selectedTab)
        .transition(.slide)
        .environment(accountVM)
    }
}

#Preview {
    NavigationStack {
        RootView(for: "675cdc1a1abc2861d5c1")
            .environment(AccountViewModel(userId: "675cdc1a1abc2861d5c1"))
            .environment(AuthViewModel())
    }
}
