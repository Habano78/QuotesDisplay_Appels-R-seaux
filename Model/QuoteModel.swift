//
//  QuoteModel.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import Foundation

// MARK: - Modèle métier
struct Quote: Identifiable {
        let id: UUID
        let text: String
        let author: String
        
        // Cet initialiseur prend un QuoteDTO en argument et l'utilise pour créer une nouvelle instance de Quote.
        init(from dto: QuoteDTO) {
                self.id = UUID()
                self.text   = dto.quoteText
                self.author = dto.quoteAuthor
        }
}
