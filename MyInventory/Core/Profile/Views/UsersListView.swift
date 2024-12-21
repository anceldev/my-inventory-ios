//
//  UsersListView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct UsersListView: View {

//    @Environment(AuthViewModel.self) var authVM
    @Environment(AccountViewModel.self) var accountVM
    @State private var friendsList: FriendsLists = .myFriends
    
    var body: some View {
        VStack(alignment: .leading) {
            Title("Usuarios", fontSize: 45)
            
            GenericSwitcher(selection: $friendsList)
            VStack {
                switch friendsList {
                case .myFriends: FriendsListView()
#if DEBUG
                        .environment(accountVM)
#endif
                case .searchFriends: SearchUserListView()
#if DEBUG
                        .environment(accountVM)
#endif
                }
            }
            Spacer()
        }
        .padding(24)
        .background(.neutral100)
    }
}

#Preview {
    UsersListView()
        .environment(AccountViewModel(userId: "675cdc1a1abc2861d5c1"))
//        .environment(AuthViewModel())
}
