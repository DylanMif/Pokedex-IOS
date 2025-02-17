//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
