//
//  PokemonService.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import Foundation

class PokemonService {
    static let shared = PokemonService()
    private let baseUrl = "https://pokeapi.co/api/v2"
    
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        fetch(endpoint: "/pokemon/\(id)", completion: completion)
    }
    
    func fetchPokemonForm(id: Int, completion: @escaping (Result<PokemonForm, Error>) -> Void) {
        fetch(endpoint: "/pokemon-form/\(id)", completion: completion)
    }
    
    func fetchAbilityDetails(id: Int, completion: @escaping (Result<Ability, Error>) -> Void) {
        fetch(endpoint: "/ability/\(id)", completion: completion)
    }
    
    func fetchMoveDetails(id: Int, completion: @escaping (Result<MoveDetail, Error>) -> Void) {
        fetch(endpoint: "/move/\(id)", completion: completion)
    }
    
    func fetchSpeciesDetails(id: Int, completion: @escaping (Result<PokemonSpecies, Error>) -> Void) {
        fetch(endpoint: "/pokemon-species/\(id)", completion: completion)
    }
    
    private func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
