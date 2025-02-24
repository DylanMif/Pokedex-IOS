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

    func fetchKantoRegion() async throws -> Region {
        guard let url = URL(string: "\(baseUrl)/region/1") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Region.self, from: data)
    }
    
    func fetchLocation(url: String) async throws -> Location {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Location.self, from: data)
    }
    
    func fetchMethod(url: String) async throws -> EncounterMethod {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(EncounterMethod.self, from: data)
    }
    
    func fetchLocationArea(url: String) async throws -> LocationArea {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Debugger la réponse
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        
        // Voir les données reçues
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON reçu: \(jsonString)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(LocationArea.self, from: data)
        } catch {
            print("Erreur de décodage: \(error)")
            throw error
        }
    }

    func fetchPokemonFromUrl(url: String) async throws -> PokemonDetail {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
    
    
    func fetchPokemonList(offset: Int, limit: Int = 20, completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/pokemon?offset=\(offset)&limit=\(limit)") else { return }
        
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
        guard let url = URL(string: "\(baseUrl)/pokemon?limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        
        return response.results.filter { pokemon in
            pokemon.name.lowercased().contains(query.lowercased())
        }
    }
}
