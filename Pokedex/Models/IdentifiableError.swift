//
//  IdentifiableError.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import Foundation


struct IdentifiableError: Identifiable {
    var id: String { message }
    let message: String
}
