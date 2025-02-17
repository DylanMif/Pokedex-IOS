//
//  PokemonEntity+CoreDataProperties.swift
//  Pokedex
//
//  Created by Pham Huynh Tuong Vy on 17/02/2025.
//
//

import Foundation
import CoreData


extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension PokemonEntity : Identifiable {

}
