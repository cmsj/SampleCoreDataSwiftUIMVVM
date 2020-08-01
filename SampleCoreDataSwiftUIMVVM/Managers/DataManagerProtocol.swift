//
//  DataManagerProtocol.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 01/08/2020.
//

import Foundation

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
