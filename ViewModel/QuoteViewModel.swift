//
//  QuoteViewModel.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//
import SwiftUI

@MainActor
class QuoteViewModel: ObservableObject {
        
        /// optionnelle car au début, ou en cas d'erreur, il se peut qu'il n'y ait pas de citation à afficher.
        @Published var quote: Quote?
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        
        //MARK: Ici, nous déclarons que chaque instance de QuoteViewModel aura une propriété constante nommée quoteService. Cette propriété déclarée est typée avec le protocole QuoteServiceProtocol
        private let quoteService: QuoteServiceProtocol
        //L'initialiseur attend un objet conforme au protocole.
        init (quoteService: QuoteServiceProtocol) {
                self.quoteService = quoteService
        }
        
        // MARK: Maintenant, nous allons ajouter la méthode principale de ce ViewModel : celle qui va demander au quoteService de récupérer une citation, puis mettre à jour les propriétés @Published en conséquence.
        
        func getQuoteForDisplay() async {
                self.isLoading = true
                self.errorMessage = nil
                defer { self.isLoading = false }
                
                // Appel au service dans un bloc do-catch
                do {
                        // 1. Appeler la méthode fetchQuote() de notre service pour obtenir QuoteDTO
                        //    C'est une opération asynchrone (await) qui peut lancer une erreur (try).
                        //    Si elle réussit, elle retourne un QuoteDTO.
                        //    self.quoteService.fetchQuote() est bien l'appel à la méthode fetchQuote() de l'objet service que le ViewModel détient (QuoteServiceProtocol)
                        let quoteDTO = try await self.quoteService.fetchQuote()
                        
                        // 2. C'est l'étape où nous convertissons les données brutes de l'API (contenues dans quoteDTO) en un objet Quote propre et structuré,
                        //    Cette ligne appelle l'initialiseur init(from: QuoteDTO) de la structure Quote
                        //    L'init crée une nouvelle instance de Quote, lui assigne un nouvel id UUID, et copie les informations pertinentes (quoteText, quoteAuthor) du quoteDTO dans les propriétés text et author du nouvel objet Quote.
                        //    C'est ici aussi que vous pourriez "nettoyer" les données si besoin
                        //    (par exemple, enlever les espaces en trop de quoteAuthor).
                        let newQuote = Quote(from: quoteDTO)
                        
                        // 3. Mettre à jour la propriété @Published 'quote'.
                        //    Puisque 'quote' est @Published et que notre ViewModel est @MainActor,
                        //    SwiftUI mettra automatiquement à jour toutes les vues qui observent cette propriété.
                        self.quote = newQuote //mise à jour la valeur de la propriété quote
                        
                        print("Citation chargée avec succès : \(newQuote.text)") // Pour débogage
                        
                } catch let caughtError {
                        // 4. Si une erreur est lancée par quoteService.fetchQuote(), elle est attrapée ici.
                        //    'caughtError' contiendra l'erreur (qui devrait être une de nos NetworkError).
                        //    Nous mettons à jour errorMessage pour que l'UI puisse afficher un message.
                        print("Erreur lors de la récupération de la citation : \(caughtError.localizedDescription)") // Pour débogage
                        
                        // Vous pouvez personnaliser le message d'erreur basé sur le type d'erreur si besoin.
                        // Par exemple, en testant si 'caughtError' est une 'NetworkError' et en utilisant un switch.
                        // Pour l'instant, un message générique :
                        if let networkError = caughtError as? NetworkError {
                                // Message plus spécifique si c'est une NetworkError
                                switch networkError {
                                case .invalidURL:
                                        self.errorMessage = "L'URL de l'API n'est pas valide."
                                case .requestFailed(let underlyingError):
                                        self.errorMessage = "La requête réseau a échoué. \(underlyingError?.localizedDescription ?? "Details Indisponibles")"
                                case .unexpectedStatusCode(let code):
                                        self.errorMessage = "Réponse inattendue du serveur (Code: \(code))."
                                case .noData:
                                        self.errorMessage = "Aucune donnée reçue du serveur."
                                case .decodingFailed(let underlyingError):
                                        self.errorMessage = "Impossible de lire les données de la citation. \(underlyingError?.localizedDescription ?? "Details Indisponibles")"
                                case .unknownError(let underlyingError):
                                        self.errorMessage = "Une erreur inconnue est survenue. \(underlyingError?.localizedDescription ?? "Details Indisponibles")"
                                        // Si vous aviez ajouté .invalidResponseType :
                                        // case .invalidResponseType:
                                        //     self.errorMessage = "Le type de réponse du serveur est invalide."
                                }
                        } else {
                                // Pour toute autre erreur non explicitement gérée comme NetworkError
                                self.errorMessage = "Une erreur est survenue : \(caughtError.localizedDescription)"
                        }
                }
        }
}
