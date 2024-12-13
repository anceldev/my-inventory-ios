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
            VStack {
                TextField("Nombre", text: $name)
                    .customTextField(icon: "shippingbox")
                Button {
                    print("Add box")
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
        
        dismiss()
    }
}
