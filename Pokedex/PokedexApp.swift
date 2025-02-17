//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
