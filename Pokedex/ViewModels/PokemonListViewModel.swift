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
    
    func loadPokemons() {
            guard !isLoading && canLoadMore else { return }
        
            isLoading = true
        PokemonService.shared.fetchPokemonList(offset: currentOffset) { [weak self] result in
                guard let self = self else { return }
            
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let response):
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
            let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
            if pokemons.firstIndex(where: { $0.id == pokemon.id }) == thresholdIndex {
                loadPokemons()
            }
        }
}
