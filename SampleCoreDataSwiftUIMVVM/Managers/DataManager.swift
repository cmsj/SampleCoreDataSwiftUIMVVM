//
//  DataManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine

// MARK: - Core Data manager
class DataManager: DataManagerBase {
    static let shared = DataManager()
    var dbHelper: CoreDataHelper

    init(inMemory: Bool = false) {
        dbHelper = CoreDataHelper(inMemory: inMemory)
        super.init()

        if inMemory && ProcessInfo.processInfo.arguments.contains("UI-TESTING") {
            // We're running in UI Testing or SwiftUI Previews or something, unconditionally restore some defaults
            restoreDefaults()
        }

        // Check if we have invalid data and if so, reset to defaults
        defaultsIfInvalid()
    }

    override func fetchCEO() -> Person {
        let people = fetchPeople(ceo: true)
        if people.count == 0 {
            return Person()
        }
        return people.first!
    }

    override func fetchPeople() -> [Person] {
        return fetchPeople(ceo: false)
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

    override func fetchPerson(personID: UUID) -> Person {
        let predicate = NSPredicate(format: "uuid == %@", personID as CVarArg)
        let result: Result<Person?, Error> = dbHelper.fetchFirst(Person.self, predicate: predicate)
        switch result {
        case .success(let person):
            return person!
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }

    override func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
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

    override func deletePerson(person: Person) {
        dbHelper.delete(person)
        self.objectWillChange.send()
    }

    override func updatePerson(person: Person) {
        self.objectWillChange.send()
        dbHelper.update(person)
    }

    override func deleteAll() {
        self.objectWillChange.send()
        dbHelper.deleteAll(Person.self)
    }

    override func restoreDefaults() {
        deleteAll()

        addPerson(name: "Jonny Appleseed", ceo: true, visitReason: .Staff, days: Set(0..<7))
        addPerson(name: "Billy Windowson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
        addPerson(name: "Alice Cryptoni", ceo: false, visitReason: .Corp, days: Set(1..<6))

        dbHelper.saveContext()
        print("Restored defaults")
    }

    override func defaultsIfInvalid() {
        let ceo = fetchPeople(ceo: true)

        if ceo.count != 1 {
            deleteAll()
            restoreDefaults()
        }
    }
}
