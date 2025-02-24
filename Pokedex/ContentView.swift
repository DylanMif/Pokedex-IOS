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
    
    @State private var selectedTheme: Theme = .system
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            PokemonListView()
                .preferredColorScheme(getColorScheme())
                .navigationBarItems(trailing: Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                        .foregroundColor(.black)
                })
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(selectedTheme: $selectedTheme)
        }
        
    }
    
    private func getColorScheme() -> ColorScheme? {
        switch selectedTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

struct SettingsView: View {
    @Binding var selectedTheme: Theme
    
    var body: some View {
        Form {
            Section(header: Text("Apparence")) {
                Picker("Thème", selection: $selectedTheme) {
                    Text("Clair").tag(Theme.light)
                    Text("Sombre").tag(Theme.dark)
                    Text("Système").tag(Theme.system)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

#Preview {
    ContentView()
}
