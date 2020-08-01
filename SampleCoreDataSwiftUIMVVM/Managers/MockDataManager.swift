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

class MockDataManager: DataManagerBase {
    private var ceo: Person
    private var normalPeople: [Person]

    override init() {
        ceo = mockCEO
        normalPeople = mockNormalPeople
    }

    func populate() {
        ceo = mockCEO
        normalPeople = mockNormalPeople
    }

    override func fetchCEO() -> Person {
        return ceo
    }

    override func fetchPeople() -> [Person] {
        return normalPeople
    }

    override func addPerson(name: String, ceo: Bool, visitReason: VisitReason, days: Set<Int>) {
        self.objectWillChange.send()
        normalPeople.append(Person(id: UUID(), ceo: ceo, name: name, reason: visitReason, daysAllowed: days))
    }

    override func deletePerson(person: Person) {
        let index = normalPeople.firstIndex(of: person)
        self.objectWillChange.send()
        normalPeople.remove(at: index!)
    }

    override func updatePerson(person: Person) {
        self.objectWillChange.send()
        return
    }

    override func deleteAll() {
        self.objectWillChange.send()
        normalPeople = []
    }

    override func restoreDefaults() {
        populate()
    }

    override func defaultsIfInvalid() {
        return
    }
}
