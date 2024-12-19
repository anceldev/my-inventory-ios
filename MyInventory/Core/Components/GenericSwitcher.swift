//
//  GenericSwitcher.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct GenericSwitcher<T: CaseIterable & Equatable & SwitcherCase>: View where T.AllCases: RandomAccessCollection {
    
    @Binding var selection: T
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(T.allCases, id: \.title) { item in
                Button {
                    withAnimation(.easeIn) {
                        selection = item
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .foregroundStyle(selection == item ? .neutral600 : .neutral300)
                        Circle()
                            .fill(.neutral200)
                            .frame(width: 22, height: 22)
                            .overlay(alignment: .center) {
                                Text("\(item.count)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.neutral600)
                            }
                    }
                }
                .foregroundStyle(selection == item ? .neutral600 : .neutral400)
            }
        }
        .font(.system(size: 22))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
//
//#Preview {
//    @Previewable @State var selection: FriendsLists = .myFriends
//    FriendsLists.counts[.myFriends] = 10
//    FriendsLists.counts[.searchFriends] = 2
//    return GenericSwitcher(selection: $selection)
//}
