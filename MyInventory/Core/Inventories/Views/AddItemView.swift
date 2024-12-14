//
//  AddItemView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 14/12/24.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    enum FormField {
        case name
        case description
        case status
        case amount
    }
    
    @State private var name = ""
    @State private var description = ""
    @State private var status: ItemStatus = .new
    @State private var amount: Int = 0
    @State private var boxId = ""
    @State private var addedBy = ""
    
    @FocusState private var focused: FormField?
    
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
                    .submitLabel(.go)
                    .onSubmit {
                        addItem()
                    }
            }
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.neutral200)
    }
    private func addItem() {
        print("Adding item...")
    }
}

#Preview {
    AddItemView()
}
