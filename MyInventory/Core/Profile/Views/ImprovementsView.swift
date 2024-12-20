//
//  ImprovementsView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import SwiftUI

struct ImprovementsView: View {
    @Environment(SuggestionsViewModel.self) var suggestionsVM
    @State private var improvement: Improvement = .implemented
    @State private var newImprovement = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Title("Mejoras", fontSize: 40)
                VStack(spacing: 16) {
                    GenericSwitcher(selection: $improvement, fontSize: 12)
                    VStack {
                        switch improvement {
                        case .approved: SuggestionList(suggestionsVM.filterSuggestion(for: .approved))
                        case .implemented: SuggestionList(suggestionsVM.filterSuggestion(for: .implemented))
                        case .review: SuggestionList(suggestionsVM.filterSuggestion(for: .review))
                        }
                    }
                    Spacer()
                }
            }
            VStack {
                Spacer()
                Button {
                    newImprovement.toggle()
                } label: {
                    Circle()
                        .fill(.greenDark)
                        .frame(width: 50, height: 50)
                        .overlay(alignment: .center) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 30)
                }

            }
        }
        .padding(24)
        .background(.neutral100)
        .sheet(isPresented: $newImprovement) {
            AddSuggestionView()
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ImprovementsView()
        .environment(SuggestionsViewModel())
}
