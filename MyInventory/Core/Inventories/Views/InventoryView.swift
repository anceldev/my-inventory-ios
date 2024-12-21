//
//  InventoryView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct InventoryView: View {
    
    enum InventoryList {
        case boxes
        case items
    }
    
    let inventory: Inventory
    @State private var list: InventoryList = .boxes
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    
    init(_ inventory: Inventory) {
        self.inventory = inventory
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(inventory.name)
                .font(.system(size: 30, weight: .bold))
            VStack {
                HStack {
                    HStack {
                        Label("Box", systemImage: "shippingbox")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.purpleDark)
                            .font(.system(size: 24))
                        Text("3")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Label("Item", systemImage: "die.face.3")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.pinkDark)
                            .font(.system(size: 24))
                        Text("3")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Label("Clock", systemImage: "clock")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 24))
                            .foregroundStyle(.neutral400)
                        Text("3")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                HStack {
                    LazyVGrid(columns: columns) {
                        ForEach(inventory.users) { user in
                            Image(user.avatar.rawValue)
                                .resizable()
                                .aspectRatio(1/1, contentMode: .fit)
                                .frame(width: 60)
                                .overlay {
                                    Circle()
                                        .stroke(.white, lineWidth: 1.5)
                                }
                        }
                    }
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(.neutral200)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .neutral300, radius: 1, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.neutral300, lineWidth: 1.5)
            }
            VStack {
                HStack(spacing: 16) {
                    Button {
                        withAnimation(.easeIn) {
                            self.list = .boxes
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("Cajas")
                                .foregroundStyle(list == .boxes ? .neutral600 : .neutral400)
                                .font(.system(size: 18))
                            Circle()
                                .fill(.neutral200)
                                .frame(width: 20, height: 20)
                                .overlay(alignment: .center) {
                                    Text("8")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.neutral600)
                                }
                        }
                    }
                    Button {
                        withAnimation(.easeIn) {
                            self.list = .items
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("Items")
                                .foregroundStyle(list == .items ? .neutral600 : .neutral400)
                                .font(.system(size: 18))
                            Circle()
                                .fill(.neutral200)
                                .frame(width: 20, height: 20)
                                .overlay(alignment: .center) {
                                    Text("3")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.neutral600)
                                }
                        }
                    }
                    .foregroundStyle(list == .items ? .neutral600 : .neutral400)
                }
                .font(.system(size: 22))
                .frame(maxWidth: .infinity, alignment: .leading)
//                ScrollView(.vertical) {
//                    switch list {
//                    case .boxes: BoxesList()
//                    case .items: ItemsList()
//                    }                    
//                }
                .scrollIndicators(.hidden)
            }
            Spacer(minLength: 0)
            
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.neutral100)
    }
}

#Preview {
    InventoryView(Inventory.preview)
}
