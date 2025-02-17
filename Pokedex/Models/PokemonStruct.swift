//
//  PokemonStruct.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import Foundation

struct Pokemon: Identifiable, Decodable {
    var id: Int {
            if let idStr = url.split(separator: "/").last,
               let id = Int(idStr) {
                return id
            }
            return 0
        }
    var name: String
    var url: String
    var imageUrl: String {
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        }
}

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
