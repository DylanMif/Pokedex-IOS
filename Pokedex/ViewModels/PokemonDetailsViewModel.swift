//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import Foundation

class PokemonDetailsViewModel : ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
}
