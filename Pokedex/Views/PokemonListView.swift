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
                    Text("#\(pokemon.id)")
                    AsyncImageView(url: pokemon.imageUrl)
                        .frame(width: 50, height: 50)
                    Text(pokemon.name.capitalized)
                }.onAppear {
                    self.viewModel.loadMoreIfNeeded(pokemon: pokemon)
                }
            }
            .navigationBarTitle("Pokédex")
            .onAppear {
                self.viewModel.loadInitialData()
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                            Spacer().frame(height: 20)
                        }
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
