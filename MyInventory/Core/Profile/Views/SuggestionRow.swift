//
//  SuggestionRow.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import SwiftUI

struct SuggestionRow: View {
    
    let suggestion: Suggestion
    let rowHeight: CGFloat = 30
    @State private var showAll = false
    
    init(for suggestion: Suggestion) {
        self.suggestion = suggestion
        self.showAll = showAll
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(suggestion.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.neutral600)
                Spacer(minLength: 0)
                
                VStack {
                    Text(suggestion.status.name)
                        .font(.system(size: 11))
                        .lineSpacing(12)
                        .foregroundStyle(suggestion.status.foreground)
                        .fontWeight(.medium)
                }
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(suggestion.status.background)
                .clipShape(.capsule)
                .frame(minWidth: 56)
                .frame(height: 16)
            }
            VStack(spacing: 8) {
                Text(suggestion.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14))
                    .foregroundStyle(.neutral800)
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            showAll.toggle()
                        }
                    } label: {
                        Text(showAll ? "Ver menos" : "Ver todo")
                            .font(.system(size: 14))
                            .foregroundStyle(.purpleDark)
                            .underline()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            }
            .frame(height: showAll ? nil : rowHeight)
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
