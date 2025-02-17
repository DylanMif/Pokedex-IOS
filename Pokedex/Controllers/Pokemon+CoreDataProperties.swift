//
//  Pokemon+CoreDataProperties.swift
//  Pokedex
//
//  Created by Pham Huynh Tuong Vy on 17/02/2025.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension Pokemon : Identifiable {

}
