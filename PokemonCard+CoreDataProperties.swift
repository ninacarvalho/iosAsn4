//
//  PokemonCard+CoreDataProperties.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//
//

import Foundation
import CoreData


extension PokemonCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonCard> {
        return NSFetchRequest<PokemonCard>(entityName: "PokemonCard")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?

}

extension PokemonCard : Identifiable {

}
