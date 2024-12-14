//
//  AddBoxView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import SwiftUI

struct AddBoxView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nueva caja")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.neutral700)
            VStack(spacing: 16) {
                TextField("Nombre", text: $name)
                    .customTextField(icon: "shippingbox")
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .onSubmit {
                        createBox()
                    }
                Button {
                    createBox()
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
        }
        .padding(24)
        .background(.neutral200)
    }
    private func createBox() {
        print("Add box")
        dismiss()
    }
}
