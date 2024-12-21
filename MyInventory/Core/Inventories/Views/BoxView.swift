//
//  BoxView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 21/12/24.
//

import SwiftUI

struct BoxView: View {
    let box: Box
    @Binding var items: [Item]
    @State private var showAddItem = false
    @Environment(AccountViewModel.self) var accountVM
    
    init(_ box: Box, items: Binding<[Item]>) {
        self.box = box
        self._items = items
    }
    
    private var boxItems: [Item] {
        items.filter { $0.boxId == box.id }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Title(box.name, fontSize: 32)
                Spacer(minLength: 0)
                Image(systemName: "shippingbox")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.purpleBase)
                    
            }
            VStack {
                ScrollView(.vertical) {
                    ForEach(boxItems ) { item in
                        VStack {
                            Text(item.name)
                            Text(item.amount, format: .number)
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(.neutral100)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    showAddItem.toggle()
                } label: {
                    Label("Add inventory", systemImage: "plus")
                }
                .foregroundStyle(.neutral700)
            }
        }
        .sheet(isPresented: $showAddItem) {
            AddItemView(items: $items, to: box.id)
//                .presentationDetents([.large])
                .environment(accountVM)
        }
    }
}
