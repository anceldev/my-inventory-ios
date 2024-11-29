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
        NavigationStack {
            VStack {
                Color.pink
            }
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        self.selectedTab = .inventories
                    } label: {
                        Image(systemName: "archivebox.fill")
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        selectedTab = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedTab = .profile
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            })
            .sheet(item: $selectedTab) { tab in
                switch tab {
                case .profile:
                    ProfileView()
                case .add:
                    Text("Add")
                case .inventories:
                    Text("Inventories")
            
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
            .environment(AuthViewModel())
    }
}
