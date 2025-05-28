//
//  NetworkErrors.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import Foundation

import Foundation

enum NetworkError: Error {
    // Cas : L'URL fournie ou construite pour l'appel API n'est pas valide.
    case invalidURL

    // Cas : La requête réseau elle-même a échoué.
    case requestFailed(Error?)

    // Cas : Le serveur a répondu, mais avec un code de statut HTTP inattendu.
    case unexpectedStatusCode(Int)

    // Cas : Le serveur a répondu avec succès (ex: code 200 OK), mais le corps de la réponse
    case noData

    // Cas : Les données ont été reçues du serveur, mais elles n'ont pas pu être
    // décodées dans la structure Swift attendue (notre QuoteDTO dans ce cas).
    case decodingFailed(Error?)

    // Cas : Une erreur inconnue ou non spécifiée s'est produite.
    case unknownError(Error?)
}
