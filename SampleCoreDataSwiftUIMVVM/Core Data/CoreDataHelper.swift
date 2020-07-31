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

    public var context: NSManagedObjectContext { persistentContainer.viewContext }

    // MARK: -  DBHelper Protocol

    public func create(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while creating an object: \(error)")
        }
    }

    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
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

    // MARK: - Persistent store loader
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "SampleCoreDataSwiftUIMVVM")
      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()

    // MARK: - Persistent store saver
    func saveContext () {
        let context = persistentContainer.viewContext
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
