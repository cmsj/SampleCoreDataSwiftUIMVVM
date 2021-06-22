//
//  CoreDataHelper.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import CoreData

public class CoreDataHelper: DBHelperProtocol {
    public static let shared = CoreDataHelper()

    public typealias ObjectType = NSManagedObject
    public typealias PredicateType = NSPredicate

    private var containerDescription: NSPersistentStoreDescription
    public var persistentContainer: NSPersistentContainer
    lazy public var context: NSManagedObjectContext = { persistentContainer.viewContext }()

    init(inMemory: Bool = false) {
        var containerName = "SampleCoreDataSwiftUIMVVM"
        containerDescription = NSPersistentStoreDescription()

        persistentContainer = NSPersistentContainer(name: containerName, managedObjectModel: NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!)

        if inMemory {
            containerName = "TemporaryStore"
            containerDescription.type = NSSQLiteStoreType
            containerDescription.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [containerDescription]
        }

        print("Loading database from: \(persistentContainer.persistentStoreDescriptions[0])")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: -  DBHelper Protocol
    public func create(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while creating an object: \(error)")
        }
    }

    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil, sortKey: String? = nil, sortAscending: Bool = true) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
        }
        if let sortKey = sortKey {
            let sortDesc = NSSortDescriptor(key:sortKey, ascending:sortAscending)
            request.sortDescriptors = [sortDesc]
        }
        do {
            let result = try context.fetch(request)
            return .success(result as? [T] ?? [])
        } catch {
            return .failure(error)
        }
    }

    public func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }

    public func update(_ object: NSManagedObject?) {
        if object == nil {
            print("Asked to update an empty object.")
            return
        }

        do {
            try context.save()
        } catch {
            fatalError("error saving context while updating an object")
        }
    }

    public func delete(_ object: NSManagedObject?) {
        if object == nil {
            print("Asked to delete an empty object.")
            return
        }

        do {
            context.delete(object!)
            try context.save()
        } catch {
            fatalError("error saving context while deleting an object")
        }
    }

    public func deleteAll<T: NSManagedObject>(_ objectType: T.Type) {
        let request = objectType.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.executeAndMergeChanges(using: deleteRequest)
            return
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Persistent store saver
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
