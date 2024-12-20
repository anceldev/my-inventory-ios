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
                            HStack {
                                VStack {
                                    Text("@\(user.username)")
                                }
                                Spacer(minLength: 0)
                                VStack {
                                    Button {
                                        addFriend(id: user.id)
                                    } label: {
                                        Text("Add")
                                    }
                                }
                            }
                            .padding(15)
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
    private func addFriend(id: String) {
        Task {
            await accountVM.addNewFriend(friendId: id)
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
