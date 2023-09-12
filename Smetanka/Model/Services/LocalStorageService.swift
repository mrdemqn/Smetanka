//
//  CoreDataService.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import CoreData

protocol LocalStorageServiceProtocol {
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]
    
    func save<T: NSManagedObject>(_ entity: T.Type,
                                  _ createEntityClosure: @escaping (NSManagedObjectContext) -> Void)
    
    func remove<T: NSManagedObject>(_ object: T.Type,
                                    _ deleteEntityClosure: @escaping (NSManagedObjectContext) -> Void)
}

final class LocalStorageService: LocalStorageServiceProtocol {
    
    static var favourite: [Food] = []
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FoodModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func save<T: NSManagedObject>(_ entity: T.Type,
                                  _ createEntityClosure: @escaping (NSManagedObjectContext) -> Void) {
        context.perform { [self] in
            createEntityClosure(context)
            saveContext()
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        let fetchRequest: NSFetchRequest<T> = T.fetchTypedRequest(type)
        do {
            let objects = try context.fetch(fetchRequest)
            return objects
        } catch {
            let error = error as NSError
            print("Fetch Error: \(error.userInfo)")
            return []
        }
    }
    
    func remove<T: NSManagedObject>(_ object: T.Type,
                                    _ deleteEntityClosure: @escaping (NSManagedObjectContext) -> Void) {
        do {
            deleteEntityClosure(context)
            try context.save()
        } catch {
            print("Delete Error: \(error)")
        }
    }
    
    static func saveRecipe(_ recipe: Food) {
        favourite.append(recipe)
    }
    
    static func removeRecipe(_ recipe: Food) {
        for food in favourite {
            if food.id == recipe.id {
                favourite.remove(at: 0)
                break
            }
        }
    }
}
