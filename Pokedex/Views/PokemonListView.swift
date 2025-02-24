//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    @Namespace private var namespace
    
    @State private var selectedTypeFilter: String? = nil
    @State private var sortOption: SortOption = .name
    
    @State private var zoomedPokemonId: Int? = nil
    @State private var showGameView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
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
                    
                    Text("Un beau projet Pokédex par Lan, NicoNii, Heo")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text("Filtre pokémon par type")
                        .font(.custom("Pokemon Solid", size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // Dropdown for filter
                    ZStack {
                        // Background for the dropdown button
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.pokeRed, Color.pokeRed.opacity(0.7)]),
                                                 startPoint: .topLeading,
                                                 endPoint: .bottomTrailing))
                            .frame(height: 50)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        Menu {
                            Button(action: { selectedTypeFilter = nil }) {
                                Text("Tous")
                            }
                            Button(action: { selectedTypeFilter = "Normal" }) {
                                Text("Normal")
                            }
                            Button(action: { selectedTypeFilter = "Water" }) {
                                Text("Eau")
                            }
                            Button(action: { selectedTypeFilter = "Fire" }) {
                                Text("Feu")
                            }
                            Button(action: { selectedTypeFilter = "Grass" }) {
                                Text("Plante")
                            }
                            Button(action: { selectedTypeFilter = "Electric" }) {
                                Text("Électrik")
                            }
                            Button(action: { selectedTypeFilter = "Ice" }) {
                                Text("Glace")
                            }
                            Button(action: { selectedTypeFilter = "Fighting" }) {
                                Text("Combat")
                            }
                            Button(action: { selectedTypeFilter = "Poison" }) {
                                Text("Poison")
                            }
                            Button(action: { selectedTypeFilter = "Ground" }) {
                                Text("Sol")
                            }
                            Button(action: { selectedTypeFilter = "Flying" }) {
                                Text("Vol")
                            }
                            Button(action: { selectedTypeFilter = "Psychic" }) {
                                Text("Psy")
                            }
                            Button(action: { selectedTypeFilter = "Bug" }) {
                                Text("Insecte")
                            }
                            Button(action: { selectedTypeFilter = "Rock" }) {
                                Text("Roche")
                            }
                            Button(action: { selectedTypeFilter = "Ghost" }) {
                                Text("Spectre")
                            }
                            Button(action: { selectedTypeFilter = "Dragon" }) {
                                Text("Dragon")
                            }
                            Button(action: { selectedTypeFilter = "Dark" }) {
                                Text("Ténèbres")
                            }
                            Button(action: { selectedTypeFilter = "Steel" }) {
                                Text("Acier")
                            }
                            Button(action: { selectedTypeFilter = "Fairy" }) {
                                Text("Fée")
                            }
                            
                        } label: {
                            HStack {
                                Text((translateType(type: selectedTypeFilter ?? "")))
                                .font(.custom("Pokemon Solid", size: 16))
                                .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .frame(maxWidth: 200)
                    .padding(.horizontal)
                    
                    Text("Trier pokémon par Nom ou ID")
                        .font(.custom("Pokemon Solid", size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    // Picker for sort
                    Picker("Tri par", selection: $sortOption) {
                        Text("Nom").tag(SortOption.name)
                        Text("ID").tag(SortOption.id)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.pokeRed.opacity(0.8))
                    .cornerRadius(10)
                    
                    searchBar
                    
                    Button("Lancer le Mini-jeu") {
                                            showGameView.toggle()
                                        }
                                        .padding()
                                        .background(Color.pokeRed)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .sheet(isPresented: $showGameView) {
                                            PokemonGameView()
                                        }
                    
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
            NavigationLink(
                destination: PokemonDetailsView(pokemonId: pokemon.id, namespace: namespace)
            ) {
                HStack {
                    Text("#\(pokemon.id)")
                    AsyncImageView(url: pokemon.imageUrl)
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "pokemonImage-\(pokemon.id)", in: namespace)
                        .scaleEffect(zoomedPokemonId == pokemon.id ? 1.2 : 1.0)
                    Text(pokemon.name.capitalized)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        zoomedPokemonId = pokemon.id
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            zoomedPokemonId = nil
                        }
                    }
                }
            }
            .transition(.slide)
        }
        .animation(.default, value: viewModel.searchResults)
    }
    
    private var normalList: some View {
        List(filteredAndSortedPokemons) { pokemon in
            NavigationLink(
                destination: PokemonDetailsView(pokemonId: pokemon.id, namespace: namespace)
            ) {
                HStack {
                    Text("#\(pokemon.id)")
                    AsyncImageView(url: pokemon.imageUrl)
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "pokemonImage-\(pokemon.id)", in: namespace)
                        .scaleEffect(zoomedPokemonId == pokemon.id ? 1.2 : 1.0)
                    Text(pokemon.name.capitalized)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        zoomedPokemonId = pokemon.id // Trigger zoom
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            zoomedPokemonId = nil // Reset after a short delay
                        }
                    }
                }
            }
            .transition(.slide)
            .onAppear {
                viewModel.loadMoreIfNeeded(pokemon: pokemon)
            }
        }
        .animation(.spring(), value: sortOption)
        .animation(.default, value: filteredAndSortedPokemons)
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
    
    private func translateType(type: String) -> String {
        switch type {
            case "Normal": return "Normal"
            case "Water": return "Eau"
            case "Fire": return "Feu"
            case "Grass": return "Plante"
            case "Electric": return "Électrik"
            case "Ice": return "Glace"
            case "Fighting": return "Combat"
            case "Poison": return "Poison"
            case "Ground": return "Sol"
            case "Flying": return "Vol"
            case "Psychic": return "Psy"
            case "Bug": return "Insecte"
            case "Rock": return "Roche"
            case "Ghost": return "Spectre"
            case "Dragon": return "Dragon"
            case "Dark": return "Ténèbres"
            case "Steel": return "Acier"
            case "Fairy": return "Fée"
            default: return "Tous"
            }
    }
    
}

#Preview {
    PokemonListView()
}
