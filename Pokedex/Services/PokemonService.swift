//
//  PokemonService.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import Foundation

class PokemonService {
    static let shared = PokemonService()
    
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon"
    
    // Fonction pour récupérer les Pokémon
    func fetchPokemonList(offset: Int, limit: Int = 20, completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?offset=\(offset)&limit=\(limit)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
