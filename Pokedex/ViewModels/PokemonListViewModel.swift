//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//
import SwiftUI
import Foundation

class PokemonListViewModel : ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError?
    
    private let context = DataController.shared.context
    private let pokemonService = PokemonService()
    private let repository = PokemonRepository()
    
//    func loadPokemons() {
//            isLoading = true
//            PokemonService.shared.fetchPokemonList { result in
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    switch result {
//                    case .success(let pokemons):
//                        self.pokemons = pokemons
//                    case .failure(let error):
//                        self.errorMessage = IdentifiableError(message: error.localizedDescription)
//                    }
//                }
//            }
//        }
    
    func loadPokemons() {
        Task {
            do {
                let cachedPokemons = try repository.fetchPokemonsFromCoreData()
                
                if cachedPokemons.isEmpty {
                    // Pas de pokemons en cache => on va à l’API
                    let fetched = try await pokemonService.fetchPokemons(limit: 50)
                    // On sauvegarde en base
                    try repository.savePokemons(fetched)
                    // On recharge le cache
                    let newCached = try repository.fetchPokemonsFromCoreData()
                    // On met à jour la variable
                    self.pokemons = newCached.map { Pokemon(name: $0.name ?? "", url: $0.url ?? "") }
                } else {
                    // On a déjà un cache => on le charge en mémoire
                    self.pokemons = cachedPokemons.map { Pokemon(name: $0.name ?? "", url: $0.url ?? "") }
                    // On peut décider de rafraîchir en background si nécessaire
                    // refreshInBackground()
                }
            } catch {
                print("Erreur : \(error.localizedDescription)")
            }
        }
    }
}
