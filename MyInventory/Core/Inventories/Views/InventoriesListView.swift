//
//  InventoriesView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct InventoriesListView: View {
    
    @State private var inventoriesList: InventoryType = .mine
    @State private var inventoryVM: InventoryViewModel
    
    init(for account: User) {
        self._inventoryVM = State(initialValue: InventoryViewModel(user: account))
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
        .environment(inventoryVM)
    }
}

#Preview {
    NavigationStack {
        InventoriesListView(for: User.preview)
    }
}
