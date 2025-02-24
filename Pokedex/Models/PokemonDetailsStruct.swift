//
//  PokemonDetailsStruct.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import Foundation
import SwiftUI

extension Color {
    static let pokeRed = Color(red: 0.95, green: 0.3, blue: 0.3)    // Rouge vif (Poké Ball)
    static let pokeBlue = Color(red: 0.2, green: 0.5, blue: 0.8)   // Bleu océan
    static let pokeYellow = Color(red: 1.0, green: 0.8, blue: 0.0) // Jaune électrique (Pikachu)
    static let pokeGreen = Color(red: 0.4, green: 0.8, blue: 0.4)  // Vert nature
}

struct PokemonDetail: Codable, Identifiable {
    let id: Int?
    let name: String?
    let base_experience: Int?
    let height: Int?
    let is_default: Bool?
    let order: Int?
    let weight: Int?
    let abilities: [PokemonAbility]?
    let forms: [NamedAPIResource]?
    
    let game_indices: [VersionGameIndex]?
    let held_items: [PokemonHeldItem]?
    let location_area_encounters: String?
    let moves: [PokemonMove]?
    let past_types: [PokemonTypePast]?
    let sprites: PokemonSprites?
    let cries: PokemonCries?
    let species: NamedAPIResource?
    
    let stats: [PokemonStat]?
    let types: [PokemonType]?
    
}

struct PokemonAbility: Codable{
    let is_hidden: Bool?
    let slot: Int?
    let ability: NamedAPIResource?
}

struct PokemonType: Codable {
    let slot: Int?
    let type: TypeInfo?
}

struct PokemonFormType: Codable {
    let slot: Int?
    let type: NamedAPIResource?
}

struct PokemonTypePast: Codable{
    let generation: NamedAPIResource?
    let types: [PokemonType?]
}

struct PokemonHeldItem: Codable{
    let item: NamedAPIResource?
    let version_details: [PokemonHeldItemVersion]?
}

struct PokemonHeldItemVersion: Codable{
    let version: NamedAPIResource?
    let rarity: Int?
}

struct PokemonMove: Codable{
    let move: NamedAPIResource?
    let version_group_details: [PokemonMoveVersion]?
}

struct PokemonMoveVersion: Codable{
    let move_learn_method: NamedAPIResource?
    let version_group: NamedAPIResource?
    let level_learned_at: Int?
}

struct PokemonStat: Codable {
    let stat: NamedAPIResource?
    let effort: Int?
    let base_stat: Int?
}

struct PokemonSprites: Codable {
    let front_default: String?
    let front_shiny: String?
    let front_female: String?
    let front_shiny_female: String?
    let back_default: String?
    let back_shiny: String?
    let back_female: String?
    let back_shiny_female: String?
}

struct PokemonCries: Codable{
    let latest: String?
    let legacy: String?
}

struct LocationAreaEncounter: Codable{
    let location_area: NamedAPIResource?
    let version_details: [VersionEncounterDetail]?
}

struct VersionEncounterDetail: Codable{
    let version: NamedAPIResource?
    let max_chance: Int?
    let encounter_details: Encounter?
}

struct Encounter: Codable{
    let min_level: Int?
    let max_level: Int?
    let condition_values: NamedAPIResource?
    let chance: Int?
    let method: NamedAPIResource?
}

struct PokemonColor: Codable{
    let id: Int?
    let name: String?
    let names: [Name?]
    let pokemon_species: NamedAPIResource?
}

struct PokemonForm: Codable, Identifiable {
    let id: Int?
    let name: String?
    let order: Int?
    let form_order: Int?
    let is_default: Bool?
    let is_battle_only: Bool?
    let is_mega: Bool?
    let form_name: String?
    let pokemon: NamedAPIResource?
    let types: [PokemonFormType]?
    let sprites: PokemonFormSprites?
    let version_group: NamedAPIResource?
    let names: [Name]?
    let form_names: [Name]?
}

struct PokemonFormSprites: Codable {
    let front_default: String?
    let front_shiny: String?
    let back_default: String?
    let back_shiny: String?
}

struct PokemonHabitat: Codable{
    let id: Int?
    let name: String?
    let names: [Name]?
    let pokemon_species: [NamedAPIResource]?
}

struct PokemonShape: Codable{
    let id: Int?
    let name: String?
    let awesome_names: [AwesomeName]?
    let names: [Name]?
    let pokemon_species: [PokemonSpecies]?
}

struct AwesomeName: Codable{
    let awesome_name: String?
    let language: NamedAPIResource?
}

struct PokemonSpecies: Codable{
    let id: Int?
    let name: String?
    let order: Int?
    let gender_rate: Int?
    let capture_rate: Int?
    let base_happiness: Int?
    let is_baby: Bool?
    let is_legendary: Bool?
    let is_mythical: Bool?
    let hatch_counter: Int?
    let has_gender_differences: Bool?
    let forms_switchable: Bool?
    let growth_rate: NamedAPIResource?
    let pokedex_numbers: [PokemonSpeciesDexEntry]?
    let egg_groups: [EggGroup]?
    let color: NamedAPIResource?
    let shape: NamedAPIResource?
    let evolves_from_species: NamedAPIResource?
    let evolution_chain: NamedAPIResource?
    let habitat: NamedAPIResource?
    let generation: NamedAPIResource?
    let names: [Name]?
    let pal_park_encounters: [PalParkEncounterArea]?
    let flavor_text_entries: [FlavorText]?
    let form_descriptions: [Description]?
    let genera: [Genus]?
    let varieties: [PokemonSpeciesVariety]?
}

struct Description: Codable{
    let description: String?
    let language: NamedAPIResource?
}

struct EggGroup: Codable{
    let id: Int?
    let name: String?
    let names: [Name]?
    let pokemon_species: NamedAPIResource?
}

struct PokemonSpeciesDexEntry: Codable{
    let entry_number: Int?
    let pokedex: NamedAPIResource?
}

struct Genus: Codable{
    let genus: String?
    let language: NamedAPIResource?
}

struct PalParkEncounterArea: Codable{
    let base_score: Int?
    let rate: Int?
    let area: NamedAPIResource?
}

struct PokemonSpeciesVariety: Codable{
    let is_default: Bool?
    let pokemon: NamedAPIResource?
}

struct Ability: Codable{
    let id: Int?
    let name: String?
    let is_main_series: Bool?
    let generation: NamedAPIResource?
    
    let names: [Name]?
    let effect_entries: [VerboseEffect]?
    let effect_changes: [AbilityEffectChange]?
    let flavor_text_entries: [AbilityFlavorText]?
    let pokemon: [AbilityPokemon]?
}

struct Name: Codable{
    let name: String?
    let language: NamedAPIResource?
}

struct VerboseEffect: Codable{
    let effect: String?
    let short_effect: String?
    let language: NamedAPIResource?
}

struct AbilityEffectChange: Codable{
    let effect_entries: Effect?
    let version_group: NamedAPIResource?
}

struct Effect: Codable{
    let effect: String?
    let language: NamedAPIResource?
}

struct AbilityFlavorText: Codable{
    let flavor_text: String?
    let language: NamedAPIResource?
    let version_group: NamedAPIResource?
}

struct AbilityPokemon: Codable{
    let is_hidden: Bool?
    let slot: Int?
    let pokemon: NamedAPIResource?
    
}

struct VersionGameIndex: Codable{
    let game_index: Int?
    let version: NamedAPIResource?
}

struct NamedAPIResource: Codable{
    let name: String?
    let url: String
}

// Système de couleur par type
extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

enum PokemonTypeColor {
    static func getColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return Color(hex: 0xFF9741)
        case "water": return Color(hex: 0x3692DC)
        case "grass": return Color(hex: 0x38BF4B)
        case "electric": return Color(hex: 0xFBD100)
        case "ice": return Color(hex: 0x4BD2C1)
        case "fighting": return Color(hex: 0xE0306A)
        case "poison": return Color(hex: 0xB567CE)
        case "ground": return Color(hex: 0xE87236)
        case "flying": return Color(hex: 0x89AAE3)
        case "psychic": return Color(hex: 0xFF6676)
        case "bug": return Color(hex: 0x83C300)
        case "rock": return Color(hex: 0xC8B686)
        case "ghost": return Color(hex: 0x4C6AB2)
        case "dragon": return Color(hex: 0x006FC9)
        case "dark": return Color(hex: 0x5B5466)
        case "steel": return Color(hex: 0x5A8EA2)
        case "fairy": return Color(hex: 0xFB89EB)
        default: return Color(hex: 0x919AA2)
        }
    }
}



struct TypeInfo: Codable {
    let name: String?
}

struct MoveDetail: Codable {
    let id: Int?
    let name: String?
    let accuracy: Int?
    let effect_chance: Int?
    let pp: Int?
    let priority: Int?
    let power: Int?
    let contest_combos: ContestComboSets?
    let contest_type: NamedAPIResource?
    let contest_effect: ContestType?
    let damage_class: NamedAPIResource?
    let effect_entries: [Effect]?
    let effect_changes: [EffectChange]?
    let generation: NamedAPIResource?
    let meta: MoveMetaData?
    let names: [Name]?
    let past_values: [PastMoveStatValues]?
    let stat_changes: [StatChange]?
    let super_contest_effect: SuperContestEffect?
    let target: NamedAPIResource?
    let type: NamedAPIResource?
    let learned_by_pokemon: [NamedAPIResource]?
    let flavor_text_entries: [FlavorText]?
}

struct SuperContestEffect: Codable{
    let id: Int?
    let appeal: Int?
    let flavor_text_entries: FlavorText?
    let moves: NamedAPIResource?
}

struct ContestType: Codable{
    let id: Int?
    let name: String?
    let berry_flavor: NamedAPIResource?
    let names: ContestName?
}

struct ContestName: Codable{
    let name: String?
    let color: String?
    let language: NamedAPIResource?
}

struct ContestComboSets: Codable {
    let normal: ContestComboDetail?
    let super_: ContestComboDetail?
}

struct ContestComboDetail: Codable {
    let use_before: [NamedAPIResource]?
    let use_after: [NamedAPIResource]?
}

struct EffectChange: Codable {
    let effect_entries: [Effect]?
    let version_group: NamedAPIResource?
}

struct MoveMetaData: Codable {
    let ailment: NamedAPIResource?
    let category: NamedAPIResource?
    let min_hits: Int?
    let max_hits: Int?
    let min_turns: Int?
    let max_turns: Int?
    let drain: Int?
    let healing: Int?
    let crit_rate: Int?
    let ailment_chance: Int?
    let flinch_chance: Int?
    let stat_chance: Int?
}

struct StatChange: Codable {
    let change: Int?
    let stat: NamedAPIResource?
}

struct PastMoveStatValues: Codable {
    let accuracy: Int?
    let effect_chance: Int?
    let power: Int?
    let pp: Int?
    let effect_entries: [Effect]?
    let type: NamedAPIResource?
    let version_group: NamedAPIResource?
}

struct FlavorText: Codable {
    let flavor_text: String?
    let language: NamedAPIResource?
    let version_group: NamedAPIResource?
}
