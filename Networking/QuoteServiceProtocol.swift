//
//  QuoteServiceProtocol.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import Foundation
// MARK: IMPORTANTE Le protocole dit : "N'importe quel type (classe, structure, énumération) qui veut être considéré comme un QuoteServiceProtocol doit absolument fournir une méthode appelée WorkspaceRandomQuote qui est async, peut throws des erreurs, et retourne un QuoteDTO."


protocol QuoteServiceProtocol {
        // on définit ici les exigences du service
        func fetchQuote() async throws ->QuoteDTO
}
