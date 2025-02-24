//
//  ContentView.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI
import CoreData
import UserNotifications
import Foundation

struct ContentView: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: IdentifiableError?
    
    @Namespace private var namespace
    
    @State private var selectedTheme: Theme = .system
    @State private var showSettings = false
    
    @State private var navigateToPokemonId: Int = 0
    
    var body: some View {
        NavigationStack {
            if(navigateToPokemonId == 0) {
                PokemonListView()
                    .preferredColorScheme(getColorScheme())
                    .navigationBarItems(trailing: Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                    })
                    .navigationDestination(for: Int.self) { pokemonId in
                        PokemonDetailsView(pokemonId: pokemonId, namespace: namespace)
                    }
            } else {
                PokemonDetailsView(pokemonId: navigateToPokemonId, namespace: namespace)
                    .preferredColorScheme(getColorScheme())
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(selectedTheme: $selectedTheme)
        }
        .onAppear {
            Task {
                do {
                    let center = UNUserNotificationCenter.current()
                    let settings = await center.notificationSettings()
                    
                    if settings.authorizationStatus != .authorized {
                        try await center.requestAuthorization(options: [.alert, .sound])
                    }
                    try await NotificationManager.shared.scheduleRandomPokemonNotification()
                } catch {
                    print("Erreur lors de la configuration des notifications: \(error)")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowPokemonDetail"))) { notification in
            let pokemonId = Int.random(in: 1...1000)
            navigateToPokemonId = pokemonId
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
