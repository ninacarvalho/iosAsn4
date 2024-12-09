//
//  CoreDataManager.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonStorage")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //create
    func savePokemonCard(id: String, name: String, imageURLSmall: String, imageURLLarge: String) {
        let card = StoredPokemonCard(context: context)
        card.id = id
        card.name = name
        card.imageURL = imageURLSmall
        card.imageURLLarge = imageURLLarge
        saveContext()
    }

    
    //read
    func fetchPokemonCards() -> [StoredPokemonCard] {
        let fetchRequest: NSFetchRequest<StoredPokemonCard> = StoredPokemonCard.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching cards: \(error)")
            return []
        }
    }

    //update
    func updatePokemonCard(id: String, newName: String?) {
        let fetchRequest: NSFetchRequest<StoredPokemonCard> = StoredPokemonCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let card = try context.fetch(fetchRequest).first {
                if let newName = newName {
                    card.name = newName
                }
                saveContext()
            }
        } catch {
            print("Error updating card: \(error)")
        }
    }
    
    //delete
    func deletePokemonCard(id: String) {
        let fetchRequest: NSFetchRequest<StoredPokemonCard> = StoredPokemonCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let card = try context.fetch(fetchRequest).first {
                context.delete(card)
                saveContext()
            }
        } catch {
            print("Error deleting card: \(error)")
        }
    }



}

