//
//  GenericSwitcher.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct GenericSwitcher<T: CaseIterable & Equatable & SwitcherCase>: View where T.AllCases: RandomAccessCollection {
    
    @Binding var selection: T
    let fontSize: CGFloat
    
    init(selection: Binding<T>, fontSize: CGFloat = 22) {
        self._selection = selection
        self.fontSize = fontSize
    }
    
    var body: some View {
        HStack(spacing: 16) {
            FlowLayout {
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
        }
        .font(.system(size: fontSize))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
