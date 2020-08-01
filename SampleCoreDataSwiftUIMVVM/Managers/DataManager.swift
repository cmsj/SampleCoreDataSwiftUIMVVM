//
//  DataManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine

protocol DataManagerProtocol {
    func fetchCEO() -> Person
    func fetchPeople() -> [Person]
    func fetchPerson(personID: UUID) -> Person
    func addPerson(name: String,
                   ceo: Bool,
                   visitReason: VisitReason,
                   days: Set<Int>)
    func deletePerson(person: Person)
    func updatePerson(person: Person)
    func deleteAll()
    func restoreDefaults()
    func defaultsIfInvalid()
}

class DataManagerBase: ObservableObject, DataManagerProtocol {
    func fetchCEO() -> Person {
        fatalError("DataManager subclass did not override fetchCEO")
    }

    func fetchPeople() -> [Person] {
        fatalError("DataManager subclass did not override fetchPeople")
    }

    func fetchPerson(personID: UUID) -> Person {
        fatalError("DataManager subclass did not override fetchPerson")
    }

    func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
        fatalError("DataManager subclass did not override addPerson")
    }

    func deletePerson(person: Person) {
        fatalError("DataManager subclass did not override deletePerson")
    }

    func updatePerson(person: Person) {
        fatalError("DataManager subclass did not override updatePerson")
    }

    func deleteAll() {
        fatalError("DataManager subclass did not override deleteAll")
    }

    func restoreDefaults() {
        fatalError("DataManager subclass did not override restoreDefaults")
    }

    func defaultsIfInvalid() {
        fatalError("DataManager subclass did not override defaultsIfInvalid")
    }
}

// MARK: - Core Data manager
class DataManager: DataManagerBase {
    static let shared = DataManager()
    var dbHelper: CoreDataHelper = CoreDataHelper.shared

    func getPersonMO(for event: Person) -> PersonMO? {
        let predicate = NSPredicate(
            format: "uuid = %@",
            event.id as CVarArg)
        let result = dbHelper.fetchFirst(PersonMO.self, predicate: predicate)
        switch result {
        case .success(let personMO):
            return personMO
        case .failure(_):
            return nil
        }
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
        let result: Result<[PersonMO], Error> = dbHelper.fetch(PersonMO.self, predicate: predicate)
        switch result {
        case .success(let peopleMOs):
            return peopleMOs.map { $0.convertToPerson() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }

    override func fetchPerson(personID: UUID) -> Person {
        let predicate = NSPredicate(format: "uuid == %@", personID as CVarArg)
        let result: Result<[PersonMO], Error> = dbHelper.fetch(PersonMO.self, predicate: predicate)
        switch result {
        case .success(let peopleMOs):
            let person = peopleMOs.first!
            return person.convertToPerson()
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }

    override func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
        let entity = PersonMO.entity()
        let newPerson = PersonMO(entity: entity, insertInto: dbHelper.context)
        newPerson.uuid = UUID()
        newPerson.name = name
        newPerson.isCEO = ceo
        newPerson.reason = visitReason.rawValue
        newPerson.days = days

        dbHelper.create(newPerson)
        self.objectWillChange.send()
    }

    override func deletePerson(person: Person) {
        dbHelper.delete(getPersonMO(for: person) ?? nil)
        self.objectWillChange.send()
    }

    override func updatePerson(person: Person) {
        let personMO = getPersonMO(for: person)
        if personMO == nil {
            print("Unable to fetch ManagedObject for person: \(person)")
            return
        }

        // This is a dumb way to make sure the ManagedObject has all the latest data from the Person model
        personMO!.name = person.name
        personMO!.isCEO = person.ceo
        personMO!.reason = person.reason.rawValue
        personMO!.days = person.daysAllowed

        dbHelper.update(personMO)
        self.objectWillChange.send()
    }

    override func deleteAll() {
        dbHelper.deleteAll(PersonMO.self)
        self.objectWillChange.send()
    }

    override func restoreDefaults() {
        deleteAll()

        addPerson(name: "Jonny Appleseed", ceo: true, visitReason: .Staff, days: Set(0..<7))
        addPerson(name: "Billy Windowson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
        addPerson(name: "Alice Cryptoni", ceo: false, visitReason: .Corp, days: Set(1..<6))

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
