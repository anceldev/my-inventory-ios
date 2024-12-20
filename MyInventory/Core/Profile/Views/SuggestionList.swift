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
                    SuggestionRow(for: suggestion)
                }
            }
        }
    }
}
