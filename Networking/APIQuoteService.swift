//
//  APIQuoteService.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import Foundation
// MARK: IMPORTANT. La classe APIQuoteService dit : "Je m'engage à respecter le contrat QuoteServiceProtocol. Voici comment je réalise spécifiquement la méthode WorkspaceRandomQuote() : je vais construire une URL, appeler l'API Forismatic, décoder le JSON, etc."

// Avec cette class nous créons une implémentation concrète du contrat QuoteServiceProtocol.

// MARK: L'objectif principal des étapes qui suivent est de construire de manière sûre et correcte l'URL complète que nous allons utiliser pour interroger l'API Forismatic.
class APIQuoteService: QuoteServiceProtocol {
        func fetchQuote() async throws -> QuoteDTO {
                //Nous stockons l'URL de base dans une constante pour plus de clarté.
                let baseURLString = "https://api.forismatic.com/api/1.0/"
                // 1. Initialisation de URLComponents
                // On utilise 'guard let' car l'initialiseur URLComponents(string:)
                // retourne un optionnel. Si la chaîne de base était malformée,
                // 'components' serait nil.
                guard var  components = URLComponents(string: baseURLString) else {
                        // Si l'URL de base est invalide,on lance un fatalError pour signaler le problème.
                        print("URL de base invalide : \(baseURLString)")
                        throw NetworkError.invalidURL
                }
                // Ajout des paramètres de requête (version concise)
                        components.queryItems = [
                            URLQueryItem(name: "method", value: "getQuote"),
                            URLQueryItem(name: "format", value: "json"),
                            URLQueryItem(name: "lang", value: "en")
                        ]
                // ici components.url génère l'URL complète avec tous les paramètres que nous avons spécifiés
                guard let finalURL =  components.url else {
                        // Si components.url est nil
                        throw NetworkError.invalidURL
                }
                print("URL construite : \(finalURL)")
                
                
                // MARK: par la suite nous utilisons cette finalURL pour effectuer réellement l'appel réseau et récupérer les données.
                // Étape 3.c.ii : Effectuer l'appel réseau avec URLSession
                        let (data, response): (Data, URLResponse) // Déclaration explicite du type du tuple pour la clarté

                        // La méthode data(from:delegate:) de URLSession est asynchrone et peut lancer des erreurs.
                        // Nous devons donc utiliser 'try await'.
                        // 'URLSession.shared' est une instance de session partagée, pratique pour les requêtes simples.
                        do {
                            (data, response) = try await URLSession.shared.data(from: finalURL)
                        } catch {
                            // Si URLSession.shared.data(from:) lance une erreur (ex: pas de réseau, serveur injoignable),
                            // nous l'attrapons ici et la relançons comme une de nos NetworkError pour plus de contexte.
                            // L'erreur originale 'error' est passée en valeur associée.
                            print("Échec de la requête réseau : \(error.localizedDescription)") // Pour débogage
                            throw NetworkError.requestFailed(error)
                        }

                // Étape 3.c.iii : Vérification de la réponse HTTP

                        // 1. S'assurer que la 'response' est bien une HTTPURLResponse.
                        // L'objet 'response' retourné par URLSession est de type URLResponse.
                        // Pour accéder au code de statut HTTP, nous devons le "caster" (convertir)
                        // en son sous-type HTTPURLResponse. L'opérateur 'as?' tente cette conversion
                        // et retourne nil si elle échoue.
                        guard let httpResponse = response as? HTTPURLResponse else {
                            // Ce cas est rare si l'URL est http ou https, mais c'est une vérification de robustesse.
                            // Si la réponse n'est pas une réponse HTTP, nous considérons que la requête a échoué
                            // d'une manière inattendue.
                            print("Réponse invalide : la réponse reçue n'est pas de type HTTPURLResponse.") // Pour débogage
                            // Vous pourriez créer un cas plus spécifique dans NetworkError, comme .invalidResponseType,
                            // mais pour l'instant, .requestFailed(nil) peut indiquer un échec général.
                            throw NetworkError.requestFailed(nil)
                        }

                        // 2. Vérifier le code de statut HTTP (httpResponse.statusCode).
                        // Les codes de statut dans la plage 200-299 indiquent généralement un succès.
                        // Si le code est en dehors de cette plage (ex: 404 Not Found, 500 Internal Server Error),
                        // nous considérons que c'est une erreur.
                        guard (200...299).contains(httpResponse.statusCode) else {
                            print("Échec de la requête : code de statut HTTP inattendu : \(httpResponse.statusCode)") // Pour débogage
                            // Nous lançons notre erreur personnalisée en passant le code de statut reçu.
                            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
                        }

                        // Si nous sommes arrivés jusqu'ici, cela signifie que :
                        // 1. Nous avons reçu une réponse du serveur.
                        // 2. Cette réponse est bien une réponse HTTP.
                        // 3. Le code de statut HTTP indique un succès (2xx).
                        // La prochaine étape sera donc de tenter de décoder les 'data'.

                // Étape 3.c.iv : Décodage des données JSON

                        // 1. Créer une instance de JSONDecoder.
                        //    JSONDecoder est l'outil fourni par Swift pour convertir des données JSON
                        //    en types de données Swift (structures ou classes conformes à Codable).
                        let decoder = JSONDecoder()

                        // 2. Tenter de décoder les données.
                        //    Nous utilisons un bloc do-catch car la méthode decode(_:from:)
                        //    peut lancer une erreur si le décodage échoue.
                        do {
                            // decoder.decode(QuoteDTO.self, from: data)
                            // - Le premier argument, QuoteDTO.self, indique à Swift que nous voulons
                            //   décoder les données JSON dans une instance de notre structure QuoteDTO.
                            // - Le deuxième argument, 'data', sont les données brutes que nous avons reçues du serveur.
                            // - 'try' est utilisé car decode peut lancer une erreur.
                            let quoteDTO = try decoder.decode(QuoteDTO.self, from: data)

                            // 3. Si le décodage réussit :
                            //    La variable 'quoteDTO' contient maintenant notre objet QuoteDTO peuplé
                            //    avec les données de la citation.
                            //    C'est le résultat final que notre fonction fetchRandomQuote doit retourner.
                            print("Citation décodée : \(quoteDTO)") // Pour débogage
                            return quoteDTO

                        } catch {
                            // 4. Si le décodage échoue :
                            //    Le bloc catch est exécuté. L'objet 'error' contient les détails
                            //    de l'échec du décodage (par exemple, JSON malformé, champ manquant
                            //    dans le JSON par rapport à QuoteDTO, type de données incorrect).
                            print("Échec du décodage JSON : \(error.localizedDescription)") // Pour débogage
                            // Nous relançons l'erreur comme notre propre NetworkError.decodingFailed,
                            // en lui passant l'erreur de décodage originale pour plus de contexte.
                            throw NetworkError.decodingFailed(error)
                        }
                    } // Fin de la méthode fetchRandomQuote (ou fetchQuote)
                } // Fin de la classe APIQuoteService

