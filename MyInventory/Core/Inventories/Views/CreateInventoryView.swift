//
//  CreateInventoryView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import SwiftUI

struct CreateInventoryView: View {
    
    enum FormFields {
        case name
        case description
    }
    @FocusState private var focused: FormFields?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountViewModel.self) var accountVM
    
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
                        if accountVM.account.friends.count > 0 {
                            VStack {
                                ScrollView(.vertical) {
                                    ForEach(accountVM.account.friends) { user in
                                        SmallUserRow(user: user, sharedWith: $sharedWith)
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
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding([.horizontal, .bottom],24)
        .background(.neutral200)
        .sheet(isPresented: $showNewBoxForm) {
            AddBoxView()
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
            if newValue {
                getFriends()
            }
        }
    }
    private func getFriends() {
        Task {
            await accountVM.getFriends()
        }
    }
}

#Preview {
    NavigationStack {
        CreateInventoryView()
            .environment(AccountViewModel(userId: User.preview.id))
    }
}
