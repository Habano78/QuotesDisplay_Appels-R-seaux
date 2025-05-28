//
//  QuoteDTOModel.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import Foundation

// MARK: - Modél réseau chargé uniquement du décodage JSON. Il doit correspondre exactement à la structure JSON que vous recevez de l'API.

struct QuoteDTO: Decodable {
        let quoteText: String // Le nom de la propriété "quoteText" correspond à la clé JSON.
        let quoteAuthor: String // Le nom de la propriété "quoteAuthor" correspond à la clé JSON.
}

// Data Transfer Object (DTO)

