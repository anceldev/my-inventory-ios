//
//  AddItemView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 14/12/24.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountViewModel.self) var accountVM
    
    enum FormField {
        case name
        case description
        case status
        case amount
    }
    
    @Binding var items: [Item]
    let boxId: String
    
    @State private var name = ""
    @State private var description = ""
    @State private var status: ItemStatus = .new
    @State private var amount: Int = 0
    @State private var addedBy = ""
    
    @FocusState private var focused: FormField?
    
    init(items: Binding<[Item]> ,to boxId: String) {
        self._items = items
        self.boxId = boxId
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Text("Nuevo Item")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.neutral700)
            VStack(spacing: 16) {
                TextField("Nombre", text: $name)
                    .customTextField("Nombre")
                    .autocorrectionDisabled()
                    .focused($focused, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {

                        focused = .description
                    }
                TextField("Description", text: $description)
                    .customTextField("Descripción")
                    .focused($focused, equals: .description)
                    .submitLabel(.next)
                    .onSubmit {
                        focused = nil
                    }
                SegmentedControl(state: $status, addIcon: false)
                TextField("Cantidad", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                    .customTextField("Cantidad")
                    .submitLabel(.done)
                    .onSubmit {
                        focused = nil
                    }
            }
            Button {
                addItem()
            } label: {
                Text("Añadir")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.purpleBase)
            .clipShape(.capsule)

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.neutral200)
    }
    private func addItem() {
        let newItem = Item(
            name: name,
            description: description,
            status: status,
            amount: amount,
            boxId: boxId,
            addedBy: accountVM.account.id
        )
        self.items.append(newItem)
        dismiss()
    }
}
