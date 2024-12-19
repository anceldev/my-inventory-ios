//
//  InventoriesView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct InventoriesListView: View {
    
    @State private var inventoriesList: InventoriesLists = .mine
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
//                Text("Inventarios")
//                    .font(.system(size: 60, weight: .bold))
//                    .padding(.bottom, 16)
//                    .foregroundStyle(.neutral700)
                Title("Inventarios", fontSize: 60)
                GenericSwitcher(selection: $inventoriesList)
                ScrollView(.vertical) {
                    ForEach(Inventory.inventoriesPreview) { inventory in
                        InventoryRow(inventory)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding([.horizontal, .bottom], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.neutral100)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink {
                            CreateInventoryView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Label("Add inventory", systemImage: "plus")
                        }
                        .tint(.neutral500)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InventoriesListView()
    }
}
