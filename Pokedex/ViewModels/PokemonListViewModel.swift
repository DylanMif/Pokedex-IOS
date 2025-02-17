//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import Foundation

class PokemonListViewModel : ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
}
