//
//  PersonEditorViewModel.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine
import SwiftUI

protocol PersonEditorViewModelProtocol {
    func updatePerson()
    func deletePerson()
    func hasDay(day: Int) -> Bool
    func toggleDay(day: Int)
}

class PersonEditorViewModel: ObservableObject {
    @Published var person: Person
    @ObservedObject var dataManager: DataManagerBase

    private var selfSubscriber: AnyCancellable? = nil

    init(personID: UUID, dataManager: DataManagerBase = DataManager.shared) {
        self.dataManager = dataManager
        self.person = dataManager.fetchPerson(personID: personID)

        selfSubscriber = objectWillChange.sink {
            print("PersonEditorViewModel changed")
            DispatchQueue.main.async {
                // This seems to need to be async because it's a WillChange, not a DidChange, so we need to call updatePerson *after* the changes have happened. Not sure this makes 100% sense to me, but it seems to work :shrug:
                self.dataManager.updatePerson(person: self.person)
            }
        }
    }
}

extension PersonEditorViewModel: PersonEditorViewModelProtocol {
    func updatePerson() {
        dataManager.updatePerson(person: self.person)
    }

    func deletePerson() {
        dataManager.deletePerson(person: self.person)
    }

    func hasDay(day: Int) -> Bool {
        return person.daysAllowed.contains(day)
    }

    func toggleDay(day: Int) {
        if person.daysAllowed.contains(day) {
            person.daysAllowed.remove(day)
        } else {
            person.daysAllowed.insert(day)
        }
    }
}
