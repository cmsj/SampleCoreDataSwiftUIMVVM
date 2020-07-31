//
//  MockDataManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation

var mockCEO = Person(id: UUID(), ceo: true, name: "A. Mockington", reason: .Corp, daysAllowed: Set(0..<7))

var mockNormalPeople = [
    Person(id: UUID(), ceo: false, name: "X. Livingston", reason: .Staff, daysAllowed: Set<Int>()),
    Person(id: UUID(), ceo: false, name: "Fr. Aliverson", reason: .SummerVacation, daysAllowed: Set(0..<7)),
    Person(id: UUID(), ceo: false, name: "Dr. Gonersly", reason: .SummerVacation, daysAllowed: Set(1..<6))
]

class MockDataManager {
    private var ceo: Person
    private var normalPeople: [Person]

    init() {
        ceo = mockCEO
        normalPeople = mockNormalPeople
    }

    func populate() {
        ceo = mockCEO
        normalPeople = mockNormalPeople
    }
}

extension MockDataManager: DataManagerProtocol {
    func fetchCEO() -> Person {
        return ceo
    }

    func fetchPeople() -> [Person] {
        return normalPeople
    }

    func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
        normalPeople.append(Person(id: UUID(), ceo: ceo, name: name, reason: visitReason, daysAllowed: days))
    }

    func deletePerson(person: Person) {
        let index = normalPeople.firstIndex(of: person)
        normalPeople.remove(at: index!)
    }

    func updatePerson(person: Person) {
        return
    }

    func deleteAll() {
        normalPeople = []
    }

    func restoreDefaults() {
        populate()
    }

    func defaultsIfInvalid() {
        return
    }
}
