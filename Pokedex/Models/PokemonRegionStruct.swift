//
//  PokemonRegionStruct.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/24/25.
//

import Foundation

struct Location: Codable, Identifiable {
    let id: Int
    let name: String
    let region: NamedAPIResource
    let names: [Name]
    let game_indices: [GenerationGameIndex]
    let areas: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case region
            case names
            case game_indices
            case areas
        }
}

struct GenerationGameIndex: Codable{
    let game_index: Int
    let generation: NamedAPIResource
}


struct LocationArea: Codable {
    let id: Int
    let name: String
    let game_index: Int
    let encounter_method_rates: [EncounterMethodRate]
    let location: NamedAPIResource
    let names: [Name]
    let pokemon_encounters: [PokemonEncounter]
}

struct EncounterMethodRate: Codable{
    let encounter_method: NamedAPIResource
    let version_details: [EncounterVersionDetails]
}

struct EncounterVersionDetails: Codable{
    let rate: Int
    let version: NamedAPIResource
}

struct PokemonEncounter: Codable {
    let pokemon: NamedAPIResource
    let version_details: [VersionEncounterDetail]
}

struct Region: Codable{
    let id: Int
    let locations: [NamedAPIResource]
    let name: String
    let names: [Name]
    let main_generation: NamedAPIResource
    let pokedexes: [NamedAPIResource]
    let version_groups: [NamedAPIResource]
}
