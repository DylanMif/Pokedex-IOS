//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
            NavigationView {
                List(self.viewModel.pokemons) { (pokemon) in
                    HStack {
                                        AsyncImageView(url: pokemon.imageUrl)
                                            .frame(width: 50, height: 50)
                                        Text(pokemon.name.capitalized)
                                    }
                }
                .navigationBarTitle("Pokédex")
                .onAppear {
                    self.viewModel.loadPokemons()
                }
                .overlay(
                    Group {
                        if self.viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                        }
                    }
                )
                
                .alert(item: $viewModel.errorMessage) { (error: IdentifiableError) in
                    Alert(title: Text("Erreur"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
            }
        }
}

#Preview {
    PokemonListView()
}
