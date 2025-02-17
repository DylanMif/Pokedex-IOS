//
//  DataController.swift
//  Pokedex
//
//  Created by Pham Huynh Tuong Vy on 17/02/2025.
//

import CoreData

class DataController: ObservableObject {
    static let shared = DataController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Pokedex")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
