//
//  PokemonGameStruct.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/24/25.
//

import Foundation

struct PokemonGame: Identifiable {
    var id = UUID()
    var pokemon: PokemonDetail
    var correctTypes: [String]
    var userAnswer: [String] = []
    
    mutating func checkAnswer() -> Bool {
        print(Set(userAnswer),Set(correctTypes))
        return Set(userAnswer) == Set(correctTypes)
    }
}
