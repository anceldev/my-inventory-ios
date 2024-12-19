//
//  UsersListView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct UsersListView: View {

    @Environment(AuthViewModel.self) var authVM
    @State private var friendsList: FriendsLists = .myFriends
    
    var body: some View {
        VStack(alignment: .leading) {
            Title("Usuarios", fontSize: 45)
            
            GenericSwitcher(selection: $friendsList)
            VStack {
                switch friendsList {
                case .myFriends: FriendsListView()
                case .searchFriends: SearchUserListView()
                }
            }
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    UsersListView()
        .environment(AuthViewModel())
}
