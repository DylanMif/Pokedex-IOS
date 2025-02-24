//
//  PokemonGameView.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/24/25.
//

import SwiftUI

struct PokemonGameView: View {
    @State private var currentGame: PokemonGame?
    @State private var isGameOver = false
    @State private var gameMessage = ""
    @State private var selectedType1: String = "Aucun"  // Type 1 sélectionné
    @State private var selectedType2: String = "Aucun"  // Type 2 sélectionné
    
    // Liste des types de Pokémon
    let types = ["normal", "water", "fire", "grass", "electric", "ice", "fighting", "poison", "ground", "flying", "psy", "bug", "rock", "ghost", "dragon", "dark", "steel", "fairy", "Aucun"]
    
    var body: some View {
        VStack {
            if let game = currentGame {
                Text("Devinez les types de \(game.pokemon.name?.capitalized ?? "")")
                    .font(.headline)
                    .padding()
                
                // Affichage de l'image du Pokémon
                AsyncImage(url: URL(string: game.pokemon.sprites?.front_default ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 150, height: 150)
                }

                // ComboBox pour choisir les types
                VStack(spacing: 20) {
                    Text("Choisissez le premier type")
                    Picker("Type 1", selection: $selectedType1) {
                        ForEach(types, id: \.self) { type in
                            Text(type.capitalized)
                                .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 250)
                    
                    Text("Choisissez le deuxième type")
                    Picker("Type 2", selection: $selectedType2) {
                        ForEach(types, id: \.self) { type in
                            Text(type.capitalized)
                                .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 250)
                }
                .padding()
                
                // Bouton Vérifier
                Button("Vérifier") {
                    isGameOver = true
                    gameMessage = checkAnswer() ? "Bravo ! C'est correct." : "Dommage, essayez encore."
                }
                .padding()
                .background(Color.pokeYellow)
                .foregroundColor(.black)
                .cornerRadius(8)
                
            } else {
                Button("Commencer le jeu") {
                    startNewGame()
                }
                .padding()
                .background(Color.pokeBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            // Affichage du message de fin de jeu
            if isGameOver {
                Text(gameMessage)
                    .font(.title)
                    .foregroundColor(.pokeYellow)
                    .padding()
                
                Button("Recommencer") {
                    startNewGame()
                }
                .padding()
                .background(Color.pokeGreen)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .onAppear {
            startNewGame()
        }
    }
    
    private func startNewGame() {
                Task {
                    do {
                        PokemonService.shared.fetchPokemonDetails(id: Int.random(in: 0...1000)) {result in
                            switch result {
                            case .success(let pokemonDetail):
                                let pokemon = pokemonDetail
                                currentGame?.pokemon = pokemon
                                currentGame = PokemonGame(pokemon: pokemon, correctTypes: pokemon.types?.compactMap { $0.type?.name ?? "" } ?? [])
                                currentGame!.userAnswer.removeAll()
                                selectedType1 = "Aucun"
                                selectedType2 = "Aucun"
                                isGameOver = false
                                gameMessage = ""
                            case .failure(_):
                                print("Error during fetching random Pokémon")
                            }
                        }
                    }
                }
            }
    
    private func checkAnswer() -> Bool {
        // Exclure "Aucun" des types sélectionnés
        let selectedTypes = [selectedType1, selectedType2].filter { $0 != "Aucun" }
        let correctTypesSet = Set(currentGame?.correctTypes ?? [])
        print(selectedTypes, correctTypesSet)
        
        // Vérifier si les types sélectionnés sont exactement les mêmes que les types corrects
        return Set(selectedTypes) == correctTypesSet
    }

}
