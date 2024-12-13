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
    
    @State private var selectedTab: Tabs?
    
    var body: some View {
        VStack {
            InventoriesListView()
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
            .environment(AuthViewModel())
    }
}
