//
//  StoredPokemonCard+CoreDataProperties.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//
//

import Foundation
import CoreData


extension StoredPokemonCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredPokemonCard> {
        return NSFetchRequest<StoredPokemonCard>(entityName: "StoredPokemonCard")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var imageURLLarge: String?
    @NSManaged public var name: String?

}

extension StoredPokemonCard : Identifiable {

}

extension Card {
    init(from storedCard: StoredPokemonCard) {
        self.id = storedCard.id ?? ""
        self.name = storedCard.name ?? ""
        self.images = Images(
            small: storedCard.imageURL ?? "",
            large: storedCard.imageURLLarge ?? ""
        )
    }
}
