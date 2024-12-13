//
//  CustomTextFieldModifier.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import SwiftUI

struct CustomTextFieldModifier: ViewModifier {
    let label: String?
    let icon: String?
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 14))
            }
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.neutral500.opacity(0.5))
                }
                content
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.white)
            .clipShape(.capsule)
        }
    }
}

extension View {
    func customTextField(_ label: String? = nil, icon: String? = nil) -> some View {
        modifier(CustomTextFieldModifier(label: label, icon: icon))
    }
}
//
//#Preview {
//    VStack {
//        TextField("name", text: .constant("Name"))
//            .customTextField("name", icon: "person")
//    }
//    .padding()
//    .background(.red)
//}
