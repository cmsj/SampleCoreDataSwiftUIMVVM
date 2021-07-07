//
//  DataManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine
import CoreData
import os.log

// MARK: - Core Data manager
class DataManager: ObservableObject {
    static let shared = DataManager()
    let log = Logger.dataManager
    var dbHelper: CoreDataHelper

    lazy var viewContext: NSManagedObjectContext = { dbHelper.context }()
    init(inMemory: Bool = false) {
        // function arguements are `let` but we want to be able to override inMemory, so make it a `var` instead
        var inMemory = inMemory

        // Forcibly override inMemory if we're in UI Testing or SwiftUI Preview, because we always want a fresh, temporary database each run
        if ProcessInfo.processInfo.arguments.contains("UI-TESTING") || ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            inMemory = true
        }

        log.info("Initialising with inMemory: \(inMemory)")
        dbHelper = CoreDataHelper(inMemory: inMemory)

        if inMemory {
            log.info("Detected some kind of non-production environment. Restoring defaults")
            restoreDefaults()
        }

        // Check if we have invalid data and if so, reset to defaults
        defaultsIfInvalid()
    }

    func fetchPeople(ceo: Bool) -> [Person] {
        Logger.dataManager.info("fetchPeople with ceo: \(ceo)")
        let predicate = NSPredicate(format: "isCEO == %@", NSNumber(value: ceo))
        let result: Result<[Person], Error> = dbHelper.fetch(Person.self, predicate: predicate, sortKey: "name")
        switch result {
        case .success(let people):
            return people
        case .failure(let error):
            print(error.localizedDescription)
            return []
        }
    }

    func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
        let entity = Person.entity()
        let newPerson = Person(entity: entity, insertInto: dbHelper.context)
        newPerson.uuid = UUID()
        newPerson.name = name
        newPerson.isCEO = ceo
        newPerson.reasonStore = visitReason.rawValue
        newPerson.days = days

        self.objectWillChange.send()
        dbHelper.create(newPerson)
    }

    func deleteAll() {
        self.objectWillChange.send()
        dbHelper.deleteAll(Person.self)
    }

    func restoreDefaults() {
        Logger.dataManager.info("Restoring defaults")
        deleteAll()

        addPerson(name: "Jonny Appleseed", ceo: true, visitReason: .Staff, days: Set(0..<7))
        addPerson(name: "Billy Windowson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
        addPerson(name: "Alice Cryptoni", ceo: false, visitReason: .Corp, days: Set(1..<6))

        dbHelper.saveContext()
        print("Restored defaults")
    }

    func defaultsIfInvalid() {
        Logger.dataManager.info("Checking datastore validity")
        let ceo = fetchPeople(ceo: true)

        if ceo.count != 1 {
            deleteAll()
            restoreDefaults()
        }
    }

    func save() {
        if dbHelper.context.hasChanges {
            Logger.dataManager.info("Saving")
            print("Saving!")
            dbHelper.saveContext()
        }
    }
}
