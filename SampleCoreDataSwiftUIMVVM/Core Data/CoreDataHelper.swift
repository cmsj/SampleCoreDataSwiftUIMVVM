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

    private var containerDescription: NSPersistentStoreDescription
    public var persistentContainer: NSPersistentContainer
    lazy public var context: NSManagedObjectContext = {
        Logger.dbHelper.info("Serving context")
        return persistentContainer.viewContext
    }()

    init(inMemory: Bool = false) {
        Logger.dbHelper.info("Initialising with inMemory: \(inMemory, privacy: .public)")
        var containerName = "SampleCoreDataSwiftUIMVVM"
        containerDescription = NSPersistentStoreDescription()

        persistentContainer = NSPersistentContainer(name: containerName, managedObjectModel: NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!)

        if inMemory {
            containerName = "TemporaryStore"
            containerDescription.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [containerDescription]
        }

        Logger.dbHelper.info("Loading database: \(self.persistentContainer.persistentStoreDescriptions[0], privacy: .public)")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            Logger.dbHelper.info("Database loaded.")
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
