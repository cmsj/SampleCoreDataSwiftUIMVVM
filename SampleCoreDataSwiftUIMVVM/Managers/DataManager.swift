//
//  DataManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine
import CoreData

// MARK: - Core Data manager
class DataManager: ObservableObject {
    static let shared = DataManager()
    var dbHelper: CoreDataHelper

    lazy var viewContext: NSManagedObjectContext = { dbHelper.context }()
    init(inMemory: Bool = false) {
        dbHelper = CoreDataHelper(inMemory: inMemory)

        if inMemory || ProcessInfo.processInfo.arguments.contains("UI-TESTING") {
            // We're running in UI Testing or SwiftUI Previews - unconditionally restore some defaults
            restoreDefaults()
        }

        // Check if we have invalid data and if so, reset to defaults
        defaultsIfInvalid()
    }

    func fetchPeople(ceo: Bool) -> [Person] {
        let predicate = NSPredicate(format: "isCEO == %@", NSNumber(value: ceo))
        let result: Result<[Person], Error> = dbHelper.fetch(Person.self, predicate: predicate, sortKey: "name")
        switch result {
        case .success(let people):
            return people
        case .failure(let error):
            fatalError(error.localizedDescription)
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
        deleteAll()

        addPerson(name: "Jonny Appleseed", ceo: true, visitReason: .Staff, days: Set(0..<7))
        addPerson(name: "Billy Windowson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
        addPerson(name: "Alice Cryptoni", ceo: false, visitReason: .Corp, days: Set(1..<6))

        dbHelper.saveContext()
        print("Restored defaults")
    }

    func defaultsIfInvalid() {
        let ceo = fetchPeople(ceo: true)

        if ceo.count != 1 {
            deleteAll()
            restoreDefaults()
        }
    }

    func save() {
        if dbHelper.context.hasChanges {
            print("Saving!")
            dbHelper.saveContext()
        }
    }
}
