//
//  SuggestionList.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import SwiftUI

struct SuggestionList: View {
    let suggestions: [Suggestion]
    
    init(_ suggestions: [Suggestion]) {
        self.suggestions = suggestions
    }
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(suggestions) { suggestion in
                    VStack {
                        Text(suggestion.title)
                        Text(suggestion.content)
                    }
                    .background(.gray)
                }
            }
        }
        .background(.neutral100)
        .padding(24)
    }
}

#Preview {
    SuggestionList([])
}
