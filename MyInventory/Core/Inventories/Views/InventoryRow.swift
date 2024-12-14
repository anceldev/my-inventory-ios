//
//  InventoryRow.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct InventoryRow: View {
    let inventory: Inventory
    let boxes = 2
    let objects = 9
    let lastUpdate: Date = .now
    
    
    init(_ inventory: Inventory) {
        self.inventory = inventory
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                VStack {
                    Image(.previewInventory)
                        .resizable()
                        .aspectRatio(1/1, contentMode: .fit)
                        .frame(maxWidth: 90)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 4)
                        .shadow(color: .neutral300, radius: 5)
                }
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(inventory.name)
                            .font(.system(size: 22))
                            .foregroundStyle(.neutral600)
                        Spacer(minLength: 0)
                        NavigationLink(value: inventory) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(.neutral700)
                                .padding(10)
                        }
                        .background(.white, in: .circle)
                    }
                    .navigationDestination(for: Inventory.self) { inventory in
                        Text(inventory.name)
                    }
                    HStack {
                        ForEach(Array(inventory.users.enumerated()), id: \.element.id) { index, user in
                            VStack(alignment: .leading) {
                                Image(user.avatar.rawValue)
                                    .resizable()
                                    .aspectRatio(1/1, contentMode: .fit)
                                    .frame(width: 40)
                                    .overlay {
                                        Circle()
                                            .stroke(.white, lineWidth: 1)
                                    }
                            }
                            .padding(.leading, index == 0 ? 0 : -25)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 18) {
                        HStack(spacing: 4) {
                            Label("Cajas", systemImage: "shippingbox")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.purpleBase)
                            Text("Cajas")
                        }
                        HStack(spacing: 4) {
                            Label("Items", systemImage: "die.face.3")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.pinkBase)
                            Text("Items")
                        }
                        HStack(spacing: 4) {
                        
                            Label("date", systemImage: "clock")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.neutral400)
                            Text(.now, style: .time)
                        }
                    }
                    .font(.system(size: 12, weight: .regular))
                }
            }
            .padding(15)
        }
        .background(.neutral200.opacity(0.5))
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 18))
//        .shadow(color: .neutral400, radius: 5)
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.neutral400.opacity(0.5), lineWidth: 1)
                .shadow(color: .neutral400, radius: 5, x:4 , y:2)
        }
        
    }
}
//
//#Preview(traits: .sizeThatFitsLayout, body: {
//    InventoryRow(Inventory.preview)
//        .padding(20)
//})
