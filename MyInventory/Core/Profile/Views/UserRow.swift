//
//  UserRow.swift
//  MyInventory
//
//  Created by Ancel Dev account on 21/12/24.
//

import SwiftUI

struct UserRow: View {
    
    @Environment(AccountViewModel.self) var accountVM
    let user: User

    var isFriend: Bool {
        if accountVM.account.following.contains(user.id) {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 16) {
                VStack {
                    Image(user.avatar.rawValue)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .overlay {
                            Circle()
                                .stroke(.neutral200, lineWidth: 3)
                        }
                }
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.neutral700)
                    
                    Text("@\(user.username)")
                        .font(.system(size: 14))
                        .foregroundStyle(.neutral500)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                Button {
                    toggleFriend()
                } label: {
                    Image(systemName: isFriend ? "checkmark" : "plus")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(isFriend ? Color.greenBase : Color.blueBase, in: .circle)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.neutral200, lineWidth: 1.5)
        }
    }
    private func toggleFriend() {
        Task {
                await accountVM.toggleFromFriends(friendId: user.id, isFriend: isFriend)
        }
    }
}

#Preview {
    VStack {
        UserRow(user: User.preview)
            .environment(AccountViewModel(userId: User.preview.id))
    }
    .padding(24)
    .background(.neutral100)
}
