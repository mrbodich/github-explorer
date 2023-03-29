//
//  Persistence.swift
//  Github Explorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController(inMemory: false)
    static private(set) var inMemory = PersistenceController(inMemory: false)
    
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = CoreDataContainer(name: "GithubExplorerData", inMemory: inMemory)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("###\(#function): Failed to load persistent stores:\(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    func saveViewContext(mergePolicy: NSMergePolicy = .mergeByPropertyObjectTrump) {
        saveContext(context: container.viewContext, mergePolicy: mergePolicy)
    }
    
    func saveContext(context: NSManagedObjectContext,
                     mergePolicy: NSMergePolicy = .mergeByPropertyObjectTrump) {
        if context.hasChanges {
            context.mergePolicy = mergePolicy
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

public final class CoreDataContainer: NSPersistentContainer {
    public init(name: String, inMemory: Bool = false, bundle: Bundle = .main) {
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to create mom")
        }
        super.init(name: name, managedObjectModel: mom)
        configureDefaults(inMemory)
    }
    
    private func configureDefaults(_ inMemory: Bool = false) {
        if let storeDescription = persistentStoreDescriptions.first {
            storeDescription.shouldAddStoreAsynchronously = true
            if inMemory {
                storeDescription.url = URL(fileURLWithPath: "/dev/null")
                storeDescription.type = NSInMemoryStoreType
                storeDescription.shouldAddStoreAsynchronously = false
            }
        }
    }
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
