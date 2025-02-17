//
//  ContentView.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: IdentifiableError?
    
    var body: some View {
            NavigationView {
                PokemonListView()
                .navigationBarTitle("Pokédex")
            }
        }
}


#Preview {
    ContentView()
}
