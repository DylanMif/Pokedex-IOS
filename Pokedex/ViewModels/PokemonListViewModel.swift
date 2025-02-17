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
    
    private var currentOffset = 0
    private var canLoadMore = true
    private let context = DataController.shared.context
    private let pokemonService = PokemonService()
    private let repository = PokemonRepository()
    
    func loadInitialData() {
        Task {
            do {
                let cachedPokemons = try repository.fetchPokemonsFromCoreData()
                
                await MainActor.run {
                    if cachedPokemons.isEmpty {
                        // Pas de pokemons en cache => chargement depuis l'API
                        loadPokemonsFromApi()
                    } else {
                        // On a déjà un cache => on le charge en mémoire
                        self.pokemons = cachedPokemons.map {
                            Pokemon(name: $0.name ?? "", url: $0.url ?? "")
                        }
                        // Optionnel : rafraîchir en arrière-plan
                        // refreshInBackground()
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func loadPokemonsFromApi() {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        PokemonService.shared.fetchPokemonList(offset: currentOffset) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    // Sauvegarde dans CoreData
                    do {
                        try self.repository.savePokemons(response.results)
                    } catch {
                        self.errorMessage = IdentifiableError(message: "Erreur de sauvegarde: \(error.localizedDescription)")
                    }
                    
                    // Mise à jour de la liste
                    self.pokemons.append(contentsOf: response.results)
                    self.currentOffset += 20
                    self.canLoadMore = response.next != nil
                    
                case .failure(let error):
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func loadMoreIfNeeded(pokemon: Pokemon) {
        guard let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) else { return }
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
        if index == thresholdIndex {
            loadPokemonsFromApi()
        }
    }
    
    
}
