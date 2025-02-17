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
    
    func loadPokemons() {
            isLoading = true
            PokemonService.shared.fetchPokemonList { result in
                DispatchQueue.main.async {
                    self.isLoading = false
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
