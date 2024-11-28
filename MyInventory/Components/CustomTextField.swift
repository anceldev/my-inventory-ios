//
//  CustomTextField.swift
//  MyInventory
//
//  Created by Ancel Dev account on 27/11/24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    let titleKey: String
    @Binding var text: String
    let fieldType: FieldType
    
    init(_ titleKey: String, text: Binding<String>, fieldType: FieldType) {
        self.titleKey = titleKey
        self._text = text
        self.fieldType = fieldType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if fieldType != .search {
                Text(titleKey)
                    .font(.system(size: 14, weight: .medium) )
            }
            HStack(spacing: 8) {
                Image(systemName: fieldType.icon)
                    .padding(.leading, 12)
                    .padding(.vertical, 10)
                    .foregroundStyle(.soft400)
                TextField(titleKey, text: $text)
                    .padding(.vertical, 10)
                    .font(.system(size: 14))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.strokeSoft200, lineWidth: 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
        }
    }
}

enum FieldType {
    case name
    case email
    case title
    case description
    case search
    
    var icon: String {
        switch self {
        case .name: "person"
        case .email: "envelope"
        case .title: ""
        case .description: ""
        case .search: "magnifyingglass"
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack {
        CustomTextField("Nombre", text: $text, fieldType: .name)
        CustomTextField("Email", text: $text, fieldType: .email)
        CustomTextField("Search", text: $text, fieldType: .search)
    }
    .padding(24)
}
