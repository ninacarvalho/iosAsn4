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
    @NSManaged public var hp: String?
    @NSManaged public var types: String?
    @NSManaged public var evolvesFrom: String?
    @NSManaged public var weaknesses: String?

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
        self.hp = storedCard.hp
        self.evolvesFrom = storedCard.evolvesFrom

        // Decode types JSON string
        if let typesJSON = storedCard.types {
            let decoder = JSONDecoder()
            self.types = try? decoder.decode([String].self, from: Data(typesJSON.utf8))
        } else {
            self.types = nil
        }

        // Decode weaknesses JSON string
        if let weaknessesJSON = storedCard.weaknesses {
            let decoder = JSONDecoder()
            self.weaknesses = try? decoder.decode([Weakness].self, from: Data(weaknessesJSON.utf8))
        } else {
            self.weaknesses = nil
        }
    }
}


