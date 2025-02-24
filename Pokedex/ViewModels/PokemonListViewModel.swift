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
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var searchResults: [Pokemon] = []
    
    private var searchTask: Task<Void, Never>?
    
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
                        self.currentOffset = self.pokemons.count
                        
                        loadPokemonTypes()
                        
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
    
    private func loadPokemonTypes() {
        print("Début du chargement des types pour \(pokemons.count) Pokémon")
        for (index, pokemon) in pokemons.enumerated() {
            PokemonService.shared.fetchPokemonDetails(id: pokemon.id) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detail):
                        if let types = detail.types {
                            print("Types chargés pour \(pokemon.name): \(types.map { $0.type?.name ?? "unknown" })")
                            var updatedPokemon = pokemon
                            updatedPokemon.types = types
                            self.pokemons[index] = updatedPokemon // Remplacer l’élément entier
                        } else {
                            print("Aucun type trouvé pour \(pokemon.name)")
                        }
                    case .failure(let error):
                        print("Erreur lors du chargement des types pour \(pokemon.name): \(error)")
                    }
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
    
    func performSearch() {
        // Annuler la recherche précédente si elle existe
        searchTask?.cancel()
        
        guard !searchText.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            do {
                let results = try await PokemonService.shared.searchPokemon(query: searchText)
                await MainActor.run {
                    self.searchResults = results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }
    
    
}
