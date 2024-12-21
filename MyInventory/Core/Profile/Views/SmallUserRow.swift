//
//  SmallUserRow.swift
//  MyInventory
//
//  Created by Ancel Dev account on 21/12/24.
//

import SwiftUI

struct SmallUserRow: View {
    @Environment(AccountViewModel.self) var accountVM
    let user: User
    @Binding var sharedWith: [String]
//    let action: () -> Void
    var isAdded: Bool {
        if sharedWith.contains(where: { $0 == user.id }) {
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
                        .frame(width: 40, height: 40)
                        .overlay {
                            Circle()
                                .stroke(.neutral300, lineWidth: 3)
                        }
                }
                VStack(alignment: .leading) {
                    Text("@\(user.username)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.neutral600)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    toggleFromInventory()
                } label: {
                    Image(systemName: isAdded ? "checkmark" : "plus")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(isAdded ? Color.greenBase : Color.blueBase, in: .circle)
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
    private func toggleFromInventory() {
        if sharedWith.contains(where: { $0 == user.id }) {
            sharedWith.removeAll { $0 == user.id }
            return
        }
        sharedWith.append(user.id)
    }
}

#Preview {
    VStack {
        SmallUserRow(user: User.preview, sharedWith: .constant([]))
            .environment(AccountViewModel(userId: User.preview.id))
    }
    .padding(24)
    .background(.neutral100)
}
