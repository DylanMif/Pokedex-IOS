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
    //    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
    //        guard let url = URL(string: "\(baseUrl)?limit=50") else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            guard let data = data else { return }
    //
    //            do {
    //                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
    //                completion(.success(decodedResponse.results))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
    
//    func fetchPokemons(limit: Int = 50) async throws -> [Pokemon] {
//        // 1. Construire l’URL
//        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
//            throw URLError(.badURL)
//        }
//        
//        // 2. Récupérer les données depuis l’API (async/await)
//        let (data, _) = try await URLSession.shared.data(from: url)
//        
//        // 3. Décoder la réponse JSON
//        let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
//        
//        // 4. Convertir en [Pokemon] :
//        //    On veut extraire un 'id' depuis l’URL du Pokémon : "https://pokeapi.co/api/v2/pokemon/25/"
//        let pokemons: [Pokemon] = decodedResponse.results.map { item in
//            return Pokemon(name: item.name, url: item.url)
//        }
//        
//        return pokemons
//    }
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
