//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    @State private var selectedTypeFilter: String? = nil
    @State private var sortOption: SortOption = .name
    
    var body: some View {
        NavigationView {
            ZStack {
                // Immersif background
                LinearGradient(gradient: Gradient(colors: [Color.pokeBlue, Color.pokeGreen]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Pokédex")
                        .font(.custom("Pokemon Solid", size: 30))
                        .foregroundColor(.pokeYellow)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        .padding(.top, 20)
                    
                    Text("A beautiful Pokédex app by Lan, NicoNii, Wei")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text("Filter pokemons by type")
                        .font(.custom("Pokemon Solid", size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // Picker for filter
                    Picker("Filter by Type", selection: $selectedTypeFilter) {
                        Text("All").tag(nil as String?)
                        Text("Water").tag("Water" as String?)
                        Text("Fire").tag("Fire" as String?)
                        Text("Grass").tag("Grass" as String?)
                        Text("Electric").tag("Electric" as String?)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.pokeRed.opacity(0.8))
                    .cornerRadius(10)
                    
                    Text("Sort pokemons by Name or ID")
                        .font(.custom("Pokemon Solid", size: 16))
                        .foregroundColor(.white)
                    
                    // Picker for sort
                    Picker("Sort By", selection: $sortOption) {
                        Text("Name").tag(SortOption.name)
                        Text("ID").tag(SortOption.id)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.pokeRed.opacity(0.8))
                    .cornerRadius(10)
                    
                    searchBar
                    
                    if viewModel.isSearching {
                        searchResultsList
                    } else {
                        normalList
                    }
                }
            }
            .onAppear {
                self.viewModel.loadInitialData()
            }
            .onChange(of: selectedTypeFilter) { }
            .onChange(of: sortOption) { }
            .navigationBarHidden(true)
        }
        
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            
            TextField("Rechercher un Pokémon", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.searchText) {
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
        List(filteredAndSortedPokemons) { pokemon in
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
    
    // SORT POKEMONS
    
    enum SortOption {
        case name
        case id
    }
    
    // Filter and sort pokemons
    
    private var filteredAndSortedPokemons: [Pokemon] {
        var filteredPokemons = viewModel.pokemons
        
        if let type = selectedTypeFilter {
            
                print("Filtrage par type: \(type)")
            
                filteredPokemons = filteredPokemons.filter { pokemon in
                    let hasType = pokemon.types?.contains(where: { $0.type?.name?.lowercased() == type.lowercased() }) ?? false
                    
                    print("Pokemon: \(pokemon.name), Types: \(String(describing: pokemon.types)), Résultat: \(hasType)")
                    
                    return hasType
                }
            }
        
        return applySorting(to: filteredPokemons)
    }
    
    private func applySorting(to pokemons: [Pokemon]) -> [Pokemon] {
        switch sortOption {
        case .name:
            return pokemons.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .id:
            return pokemons.sorted { $0.id < $1.id }
        }
    }
    
}

#Preview {
    PokemonListView()
}
