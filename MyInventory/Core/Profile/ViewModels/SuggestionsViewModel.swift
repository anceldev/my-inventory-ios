//
//  SuggestionsViewModel.swift
//  MyInventory
//
//  Created by Ancel Dev account on 20/12/24.
//

import Foundation
import Observation

@Observable
final class SuggestionsViewModel {
    var suggestions: [Suggestion]
    var errorMessage: String?
    
    init() {
        self.suggestions = []
        self.errorMessage = nil
        Task {
            do {
                try await getSuggestions()
            } catch {
                print("Can't get suggestions")
            }
        }
    }
    
    func fetchAgain() async {
        do {
            self.errorMessage = nil
            try await getSuggestions()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    func sendSuggestion(userId: String, title: String, content: String) async {
        do {
            self.errorMessage = nil
            let suggestion = Suggestion(userId: userId, title: title, content: content)
            try await AWClient.createDocument(collection: .suggestions, model: suggestion)
            suggestions.append(suggestion)
            let actual = Improvement.counts[.review]
            Improvement.counts[.review] = actual! + 1
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = errorMessage
        }
    }
    
    private func getSuggestions() async throws {
        do {
            let suggestions: [Suggestion] = try await AWClient.getModels(collection: .suggestions)
            self.suggestions = suggestions
            Improvement.counts[.approved] = self.filterSuggestion(for: .approved).count
            Improvement.counts[.implemented] = self.filterSuggestion(for: .implemented).count
            Improvement.counts[.review] = self.filterSuggestion(for: .review).count
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func filterSuggestion(for status: Suggestion.Status) -> [Suggestion] {
        do {
            return try self.suggestions.filter(#Predicate<Suggestion> { $0.status == status })
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
}
