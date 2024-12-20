//
//  AddImprovementView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import SwiftUI

struct AddImprovementView: View {
    
    enum FormFields {
        case title
        case content
    }
    
    @Environment(SuggestionsViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @FocusState private var focused: FormFields?
    
    var body: some View {
        VStack(alignment: .leading) {
            Title("Sugerencia", fontSize: 25)
            VStack(spacing: 12) {
                TextField("Titulo", text: $title)
                    .customTextField("Título")
                    .submitLabel(.next)
                    .focused($focused, equals: .title)
                    .onSubmit {
                        focused = .content
                    }
                
                TextEditor(text: $content)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .scrollContentBackground(.hidden)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .submitLabel(.done)
                    .focused($focused, equals: .content)
                    .onSubmit {
                        focused = nil
                    }
                
                Button {
                    sendSuggestion()
                } label: {
                    Label("Enviar", systemImage: "plus")
                        .foregroundStyle(.neutral600)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.yellowBase, in: .capsule)
            }
        }
        .padding(24)
        .background(.neutral100)
    }
    private func sendSuggestion() {
        Task {
            await viewModel.sendSuggestion(userId: "", title: title, content: content)
            dismiss()
        }
    }
}
