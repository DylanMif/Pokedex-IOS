//
//  ContentView.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: IdentifiableError?
    
    var body: some View {
            NavigationView {
                List(pokemons) { pokemon in
                    Text(pokemon.name.capitalized)
                }
                .navigationBarTitle("Pokédex")
                .onAppear {
                    loadPokemons()
                }
                .overlay(
                    Group {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                        }
                    }
                )
                // Ajout d'un type explicite pour la variable 'error' ici
                .alert(item: $errorMessage) { (error: IdentifiableError) in
                    Alert(title: Text("Erreur"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    
    private func loadPokemons() {
            isLoading = true
            PokemonService.shared.fetchPokemonList { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let pokemons):
                        self.pokemons = pokemons
                    case .failure(let error):
                        self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    }
                }
            }
        }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
