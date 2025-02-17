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
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?limit=50") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
