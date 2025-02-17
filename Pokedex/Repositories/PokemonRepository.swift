//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by Pham Huynh Tuong Vy on 17/02/2025.
//

import CoreData

class PokemonRepository {
    private let context = DataController.shared.context
    
    func fetchPokemonsFromCoreData() throws -> [PokemonEntity] {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func savePokemons(_ pokemons: [Pokemon]) throws {
        for pokemon in pokemons {
            let entity = PokemonEntity(context: context)
            entity.name = pokemon.name
            entity.url = pokemon.url
        }
        try context.save()
    }
    
    // Et d’autres méthodes utilitaires si besoin
}
