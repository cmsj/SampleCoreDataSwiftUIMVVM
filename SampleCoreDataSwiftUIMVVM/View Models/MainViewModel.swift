//
//  MainViewModel.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine
import SwiftUI

protocol MainViewModelProtocol {
    var ceo: Person { get }
    var people: [Person] { get }
    func fetchCEO()
    func fetchNormalPeople()
    func fetchAllPeople()
    func newPerson()
    func deletePerson(person: Person)
    func deletePeopleAtOffsets(indexSet: IndexSet)
    func updatePerson(person: Person)
    func resetToDefaults()
}

class MainViewModel: ObservableObject {
    @Published var ceo: Person
    @Published var people = [Person]()

    @ObservedObject var dataManager: DataManagerBase
    private var dataManagerSubscriber: AnyCancellable? = nil

    init(dataManager: DataManagerBase = DataManager.shared) {
        self.dataManager = dataManager
        ceo = dataManager.fetchCEO()
        fetchAllPeople()
        self.dataManagerSubscriber = dataManager.objectWillChange
            .sink {
            print("dataManager changed, reloading MainViewModel data")
            self.fetchAllPeople()
        }
    }
}

extension MainViewModel: MainViewModelProtocol {
    func fetchCEO() {
        ceo = dataManager.fetchCEO()
    }

    func fetchNormalPeople() {
        people = dataManager.fetchPeople()
    }

    func fetchAllPeople() {
        fetchCEO()
        fetchNormalPeople()
    }

    func newPerson() {
        dataManager.addPerson(name: "Newy Newerson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
    }

    func deletePerson(person: Person) {
        dataManager.deletePerson(person: person)
    }

    func deletePeopleAtOffsets(indexSet: IndexSet) {
        // Collect up references to the people we're removing.
        // We don't do it in a single loop because then we're mutating self.people while iterating it, which is a bad idea
        var peopleToRemove = [Person]()
        for index in indexSet {
            peopleToRemove.append(people[index])
        }
        for person in peopleToRemove {
            self.deletePerson(person: person)
        }
    }

    func updatePerson(person: Person) {
        dataManager.updatePerson(person: person)
    }

    func resetToDefaults() {
        dataManager.restoreDefaults()
    }
}
