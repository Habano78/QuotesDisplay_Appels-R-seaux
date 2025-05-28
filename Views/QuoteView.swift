//
//  ContentView.swift
//  ClassQuote
//
//  Created by Perez William on 26/05/2025.
//

import SwiftUI

struct QuoteView: View {
        
        // Déclaration et initialisation du ViewModel
        // @StateObject garantit que le viewModel ne sera créé qu'une seule fois
        // pendant toute la durée de vie de la QuoteView et sera conservé.
        // Nous injectons ici directement une instance de APIQuoteService.
        // C'est le bon choix lorsque la vue est proprietaire du ViewMOdel
        @StateObject private var viewModel = QuoteViewModel(quoteService: APIQuoteService())
        
        
        var body: some View {
                
                VStack(spacing: 20) {
                        // Titre de la vue
                        Text("Citation du Moment")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        
                        // Condition 1: Gérer l'affichage d'une erreur
                        if let errorMessage = viewModel.errorMessage {
                                VStack {
                                        Image(systemName: "exclamationmark.triangle.fill") // Icône d'erreur
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.red)
                                        Text("Erreur : \(errorMessage)")
                                                .foregroundColor(.red)
                                                .multilineTextAlignment(.center)
                                }
                                
                        }else if viewModel.isLoading {
                                ProgressView("Chargement de la citation...")
                                        .padding()
                        }
                        // Condition 3: Gérer l'affichage de la citation (si pas d'erreur et pas en chargement)
                        else if let quote = viewModel.quote {
                                VStack(alignment: .leading, spacing: 10) {
                                        Text("\"\(quote.text)\"") // Le texte de la citation
                                                .font(.title2) // Une police un peu plus grande
                                                .italic()       // En italique
                                                .lineLimit(nil) // Permet au texte de s'étendre sur plusieurs lignes si nécessaire
                                                .minimumScaleFactor(0.5) // Réduit la taille de la police si le texte est trop long
                                        
                                        Text("- \(quote.author)") // L'auteur de la citation
                                                .font(.headline)
                                                .foregroundColor(.gray) // Une couleur un peu plus discrète pour l'auteur
                                                .frame(maxWidth: .infinity, alignment: .trailing) // Aligne l'auteur à droite
                                }
                                .padding() // Ajoute un peu d'espace autour du bloc de citation
                                .background(Color.gray.opacity(0.1)) // Un léger fond pour le bloc de citation
                                .cornerRadius(10) // Coins arrondis
                        }
                        // Condition 4: État initial ou si aucune citation n'est disponible (et pas d'erreur/chargement)
                        else {
                                Text("Bienvenue ! Appuyez sur le bouton ci-dessous pour obtenir une citation inspirante.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.secondary)
                        }
                        Button("Nouvelle Citation") {
                                Task {
                                        await viewModel.getQuoteForDisplay()
                                }
                        }
                        .buttonStyle(.borderedProminent) // Style de bouton plus moderne et visible
                        .padding(.top)
                        
                        Spacer() // Pousse tout le contenu vers le haut
                }
                .padding()
                
                // C'est ici que nous ajoutons le modificateur .task
                .task {
                        // Ce code sera exécuté lorsque la QuoteView apparaît.
                        // Si aucune citation n'est déjà chargée, nous en chargeons une.
                        if viewModel.quote == nil { // Optionnel: seulement si aucune citation n'est pas là
                                await viewModel.getQuoteForDisplay()
                        }
                }
        }
}
#Preview {
        QuoteView()
}
