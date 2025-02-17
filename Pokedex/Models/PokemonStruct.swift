//
//  PokemonStruct.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import Foundation

struct Pokemon: Identifiable, Decodable {
    var id: Int
    var name: String
    var image: String
    var type: String
    var pv: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
}

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}
