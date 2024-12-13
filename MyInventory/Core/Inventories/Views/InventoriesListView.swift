//
//  InventoriesView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct InventoriesListView: View {
    enum InventoriesLists {
        case mine
        case shared
    }
    
    @State private var list: InventoriesLists = .mine
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Inventarios")
                    .font(.system(size: 60, weight: .bold))
                    .padding(.bottom, 16)
                    .foregroundStyle(.neutral700)
                HStack(spacing: 16) {
                    Button {
                        withAnimation(.easeIn) {
                            self.list = .mine
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("Míos")
                                .foregroundStyle(list == .mine ? .neutral600 : .neutral400)
                            Circle()
                                .fill(.neutral200)
                                .frame(width: 22, height: 22)
                                .overlay(alignment: .center) {
                                    Text("8")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.neutral600)
                                }
                        }
                    }
                    Button {
                        withAnimation(.easeIn) {
                            self.list = .shared
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("Compartidos")
                                .foregroundStyle(list == .shared ? .neutral600 : .neutral400)
                            Circle()
                                .fill(.neutral200)
                                .frame(width: 22, height: 22)
                                .overlay(alignment: .center) {
                                    Text("3")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.neutral600)
                                }
                        }
                    }
                    .foregroundStyle(list == .shared ? .neutral600 : .neutral400)
                }
                .font(.system(size: 22))
                .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.vertical) {
                    ForEach(Inventory.inventoriesPreview) { inventory in
                        InventoryRow(inventory)
                    }
                    .navigationDestination(for: Inventory.self) { inventory in
                        Text(inventory.name)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding([.horizontal, .bottom], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.neutral100)
            
        }
        .toolbar {
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

#Preview {
    NavigationStack {
        InventoriesListView()
    }
}
