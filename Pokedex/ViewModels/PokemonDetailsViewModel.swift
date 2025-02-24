//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import Foundation
import SwiftUI

class PokemonDetailsViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    
    @Published var pokemonForms: [PokemonForm] = []
    @Published var abilityDetails: [Int: Ability] = [:]
    @Published var moveDetails: [Int: MoveDetail] = [:]
    @Published var speciesDetails: PokemonSpecies?
    
    @Published var isFavorite: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError?
        
    func loadPokemonDetails(id: Int) {
        isLoading = true
        
        // On charge d'abord l'état du favori
        do {
            isFavorite = try PokemonRepository().checkIsFavorite(pokemonId: id)
        } catch {
            print("Error loading favorite state: \(error)")
        }
        
        // Puis on charge les détails du Pokémon comme avant
        PokemonService.shared.fetchPokemonDetails(id: id) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let pokemon):
                    self.pokemon = pokemon
                    self.loadFormDetails()
                    self.loadAbilityDetails()
                    self.loadMoveDetails()
                    self.loadSpeciesDetails()
                    
                    print("Pokemon details : \(pokemon)" )
                case .failure(let error):
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }        
    }
    
    private func loadAbilityDetails() {
        guard let abilities = pokemon?.abilities else { return }
        for ability in abilities {
            guard let abilityData = ability.ability else { continue }
            guard let id = Int(abilityData.url.split(separator: "/").last ?? "0") else { continue }
            PokemonService.shared.fetchAbilityDetails(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let abilityDetail):
                        self.abilityDetails[id] = abilityDetail
                        
                        
                    case .failure(let error):
                        print("Error loading ability: \(error)")
                    }
                }
            }
        }
    }

    private func loadMoveDetails() {
        guard let moves = pokemon?.moves else { return }
        
        for move in moves {
            guard let moveData = move.move else { continue }
            guard let id = Int(moveData.url.split(separator: "/").last ?? "0") else { continue }
            
            PokemonService.shared.fetchMoveDetails(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let moveDetail):
                        self.moveDetails[id] = moveDetail
                    case .failure(let error):
                        print("Error loading move: \(error)")
                    }
                }
            }
        }
    }

    private func loadSpeciesDetails() {
        guard let pokemon = pokemon else { return }
        guard let speciesData = pokemon.species else { return }
        guard let id = Int(speciesData.url.split(separator: "/").last ?? "0") else { return }
        
        PokemonService.shared.fetchSpeciesDetails(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let speciesDetail):
                    self.speciesDetails = speciesDetail
                case .failure(let error):
                    print("Error loading species: \(error)")
                }
            }
        }
    }

    private func loadFormDetails() {
        guard let pokemon = pokemon else { return }
        guard let formsData = pokemon.forms else { return }
        for form in formsData {
            guard let id = Int(form.url.split(separator: "/").last ?? "0") else { continue }
            
            PokemonService.shared.fetchPokemonForm(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let formDetail):
                        self.pokemonForms.append(formDetail)
                    case .failure(let error):
                        print("Error loading form: \(error)")
                    }
                }
            }
        }
    }
    
    func toggleFavorite() {
        guard let pokemonId = pokemon?.id else { return }
        
        do {
            isFavorite.toggle()
            try PokemonRepository().toggleFavorite(for: pokemonId)
        } catch {
            print("Error saving favorite state: \(error)")
            // En cas d'erreur, on revient à l'état précédent
            isFavorite.toggle()
        }
    }
}

