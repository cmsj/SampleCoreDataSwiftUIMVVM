//
//  CoreDataHelper.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import CoreData
import os.log

public class CoreDataHelper {
    public static let shared = CoreDataHelper()
    let log = Logger.dbHelper

    public var persistentContainer: NSPersistentContainer
    private var containerDescription: NSPersistentStoreDescription

    // This is done as a lazy var to avoid racing with the container initialisation. This seems like a poor choice.
    lazy public var context: NSManagedObjectContext = {
        log.trace("Vending context")
        return persistentContainer.viewContext
    }()

    init(inMemory: Bool = false) {
        log.trace("Initialising with inMemory: \(inMemory, privacy: .public)")

        // The name here should match your xcdatamodeld filename
        persistentContainer = NSPersistentContainer(name: "SampleCoreDataSwiftUIMVVM")

        containerDescription = NSPersistentStoreDescription()
        if inMemory {
            // This is preferable to using containerDescription.type = NSInMemoryStoreType, because that type doesn't support batch operations
            containerDescription.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [containerDescription]
        }

        log.info("Loading database: \(self.persistentContainer.persistentStoreDescriptions[0], privacy: .public)")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // FIXME: Do something better with errors here
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            Logger.dbHelper.trace("Database loaded.")
        }
    }

    // MARK: -  DBHelper Protocol
    public func create(_ object: NSManagedObject) {
        // We don't actually need to add/create anything here, the object will already be in the context, so just flush the changes
        self.saveContext()
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

    public func deleteAll<T: NSManagedObject>(_ objectType: T.Type) {
        let request = objectType.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.executeAndMergeChanges(using: deleteRequest)
            return
        } catch {
            // FIXME: Do something better with errors here. Maybe forcibly delete the database file?
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Persistent store saver
    func saveContext () {
        if context.hasChanges {
            log.trace("Saving")
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                // FIXME: Do something better with errors here
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
