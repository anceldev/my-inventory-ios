//
//  SearchUserListView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct SearchUserListView: View {
    @Environment(AccountViewModel.self) var accountVM
    @State private var query: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Buscar", text: $query)
                Button {
                    searchUsers()
                } label: {
                    Text("Buscar")
                }
            }
            .customTextField(icon: "magnifyingglass")
            Text("Search List")
            VStack {
                if accountVM.searchedUsers.count > 0{
                    ForEach(accountVM.searchedUsers) { user in
                        if user.id != accountVM.account.id {
                            UserRow(user: user)
                        }
                    }
                }
            }
        }
        .animation(.easeIn, value: accountVM.searchedUsers.count)
        .onAppear {
            searchUsers()
        }
    }
    private func searchUsers() {
        Task {
            await accountVM.searchUsers(query: query)
        }
    }
}

#Preview {
    VStack {
        SearchUserListView()
            .environment(AccountViewModel(userId: User.preview.id))
    }
    .padding(24)
    .background(.neutral200)
}
