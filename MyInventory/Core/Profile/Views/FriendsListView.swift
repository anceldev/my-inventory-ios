//
//  FriendsListView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct FriendsListView: View {
    
    @Environment(AccountViewModel.self) var accountVM
    
    var body: some View {
        @Bindable var vm = accountVM
        VStack {
            VStack {
                if vm.account.friends.count > 0{
                    ForEach(vm.account.friends) { user in
                        if user.id != accountVM.account.id {
                            UserRow(user: user)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await accountVM.getFriends()
            }
        }
        .onChange(of: accountVM.account.friends.count) {
            for friend in accountVM.account.friends {
                print(friend.name)
            }
        }
    }
}

#Preview {
    FriendsListView()
        .environment(AccountViewModel(userId: User.preview.id))
}
