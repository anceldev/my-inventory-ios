//
//  CreateInventoryView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import Appwrite
import SwiftUI

struct CreateInventoryView: View {
    
    enum FormFields {
        case name
        case description
    }
    @FocusState private var focused: FormFields?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountViewModel.self) var accountVM
    @Environment(InventoryViewModel.self) var inventoryVM
    
    @State private var newInventoryId = Appwrite.ID.unique()
    
    @State private var showNewBoxForm = false
    @State private var name = ""
    @State private var description = ""
    @State private var ownerId = ""
    @State private var sharedWith: [String] = []
    @State private var sharedUsers: [User] = []
    @State private var boxes: [Box] = []
    @State private var items: [Item] = []
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
                    .focused($focused, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focused = .description
                    }
                    
                    TextField(text: $description) {
                        Text("Añade una descripción...")
                    }
                    .customTextField("Descripción")
                    .focused($focused, equals: .description)
                    .submitLabel(.done)
                    .onSubmit {
                        focused = nil
                    }
                    
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
                    if boxes.count > 0 {
                        BoxesList(items: $items, boxes: boxes)
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
                        if accountVM.account.friends.count > 0 {
                            VStack {
                                ScrollView(.vertical) {
                                    ForEach(accountVM.account.friends) { user in
                                        SmallUserRow(user: user, sharedWith: $sharedWith, sharedUsers: $sharedUsers)
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("Todavía no has añadido a nadíe como amigo, añade el primero y podrás compartir tu inventario con él.")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Button {
                        createInventory()
                    } label: {
                        Text("Añadir")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(.blueBase)
                    .clipShape(.capsule)
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding([.horizontal, .bottom],24)
        .background(.neutral200)
        .sheet(isPresented: $showNewBoxForm) {
            AddBoxView(to: $boxes, for: newInventoryId, userId: inventoryVM.user.id)
                .presentationDetents([.height(206)])
                .presentationBackground(Color.neutral200)
                .presentationDragIndicator(.visible)
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
        .onChange(of: isShared) { oldValue, newValue in
            if newValue == true {
                getFriends()
            } else {
                sharedWith = []
                sharedUsers = []
            }
        }
        .onAppear {
            print(newInventoryId)
        }
    }
    private func getFriends() {
        Task {
            await accountVM.getFriends()
        }
    }
    private func createInventory() {
        let newInventory = Inventory(
            id: newInventoryId,
            name: name,
            description: description,
            owener: inventoryVM.user.id,
            sharedWith: isShared ? sharedWith : [],
            users: isShared ? sharedUsers : [],
            boxes: boxes
        )
        Task {
            await inventoryVM.createInventory(inventory: newInventory, boxes: boxes, items: items)
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CreateInventoryView()
            .environment(AccountViewModel(userId: User.preview.id))
            .environment(InventoryViewModel(user: User.preview))
    }
}
