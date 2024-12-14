//
//  CreateInventoryView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import SwiftUI

struct CreateInventoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showNewBoxForm = false
    @State private var name = ""
    @State private var description = ""
    @State private var ownerId = ""
    @State private var sharedWith: [String] = []
    @State private var isShared = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: -10) {
                    Text("Nuevo")
                    Text("inventario")
                }
                .font(.system(size: 50, weight: .bold))
                .padding(.bottom, 16)
                .foregroundStyle(.neutral700)
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 16) {
                    TextField(text: $name) {
                        Text("Dale un nombre al inventario...")
                    }
                    .customTextField("Nombre")
                    
                    TextField(text: $description) {
                        Text("Añade una descripción...")
                    }
                    .customTextField("Descripción")
                    HStack {
                        Text("Cajas")
                            .font(.system(size: 14))
                        Spacer()
                        Button {
                            showNewBoxForm.toggle()
                        } label: {
                            Text("Añadir")
                                .font(.system(size: 14, weight: .medium))
                                .underline()
                        }
                    }
                    if true {
                        BoxesList()
                    }
                    HStack(alignment: .bottom) {
                        Text("Tipo:")
                            .font(.system(size: 14))
                        HStack {
                            Image(systemName: isShared ? "globe.americas.fill" : "person.fill")
                                .foregroundStyle(isShared ? .purpleBase : .blueBase)
                            Text(isShared ? "Compartido" : "Solo")
                                .foregroundStyle(.neutral500)
                                .animation(.easeIn, value: isShared)
                        }
                        .italic()
                        .font(.system(size: 16))
                        Spacer()
                        CustomToggle(isOn: $isShared)
                    }
                    if isShared {
                        VStack {
                            ScrollView(.vertical) {
                                ForEach(1..<10) { item in
                                    Text("User \(item)")
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding([.horizontal, .bottom],24)
        .background(.neutral100)
        .sheet(isPresented: $showNewBoxForm) {
            AddBoxView()
                .presentationDetents([.height(206)])
                .presentationBackground(Color.neutral200)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.neutral500)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateInventoryView()
    }
}
