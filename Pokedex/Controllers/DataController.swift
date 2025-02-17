//
//  DataController.swift
//  Pokedex
//
//  Created by Pham Huynh Tuong Vy on 17/02/2025.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Pokedex")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
