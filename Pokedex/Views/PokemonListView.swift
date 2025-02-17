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
                VStack {
                    searchBar
                    
                    if viewModel.isSearching {
                        searchResultsList
                    } else {
                        normalList
                    }
                }.onAppear {
                    self.viewModel.loadInitialData()
                }
                .navigationBarTitle("Pokédex")
            }
        }
    
    private var searchBar: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Rechercher un Pokémon", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.performSearch()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
    
    private var searchResultsList: some View {
        List(viewModel.searchResults) { pokemon in
            NavigationLink(destination: PokemonDetailsView(pokemonId: pokemon.id)) {
                HStack {
                    Text("#\(pokemon.id)")
                    AsyncImageView(url: pokemon.imageUrl)
                        .frame(width: 50, height: 50)
                    Text(pokemon.name.capitalized)
                }
            }
        }
    }
    
    private var normalList: some View {
        List(viewModel.pokemons) { pokemon in
            NavigationLink(destination: PokemonDetailsView(pokemonId: pokemon.id)) {
                HStack {
                    Text("#\(pokemon.id)")
                    AsyncImageView(url: pokemon.imageUrl)
                        .frame(width: 50, height: 50)
                    Text(pokemon.name.capitalized)
                }
            }
            .onAppear {
                viewModel.loadMoreIfNeeded(pokemon: pokemon)
            }
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
    }
}

#Preview {
    PokemonListView()
}
