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
        let sortByID = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortByID]
        return try context.fetch(request)
    }
    
    func savePokemons(_ pokemons: [Pokemon]) throws {
        for pokemon in pokemons {
            let entity = PokemonEntity(context: context)
            entity.id = Int64(pokemon.id)
            entity.name = pokemon.name
            entity.url = pokemon.url
            entity.isFavorite = NSNumber(value: false)
        }
        try context.save()
    }
    
    func toggleFavorite(for pokemonId: Int) throws {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", pokemonId)
        
        let results = try context.fetch(request)
        if let pokemon = results.first {
            pokemon.isFavorite = NSNumber(value: !(pokemon.isFavorite?.boolValue ?? false))
            try context.save()
        } else {
            let entity = PokemonEntity(context: context)
            entity.id = Int64(pokemonId)
            entity.isFavorite = NSNumber(value: true)
            try context.save()
        }
    }

    func checkIsFavorite(pokemonId: Int) throws -> Bool {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", pokemonId)
        
        let results = try context.fetch(request)
        return results.first?.isFavorite?.boolValue ?? false
    }
    
}
