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
    
    func searchPokemon(query: String) async throws -> [Pokemon] {
            // L'API Pokemon ne supporte pas directement la recherche,
            // donc nous devons charger une plus grande liste et filtrer
            let limit = (1500)
            guard let url = URL(string: "\(baseUrl)?limit=\(limit)") else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            
            return response.results.filter { pokemon in
                pokemon.name.lowercased().contains(query.lowercased())
            }
        }
    
}
