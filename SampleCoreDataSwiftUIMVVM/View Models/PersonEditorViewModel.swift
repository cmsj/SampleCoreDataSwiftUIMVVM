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

    init(person: Person, dataManager: DataManagerBase = DataManager.shared) {
        self.dataManager = dataManager
        self.person = person

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
        return person.days!.contains(day)
    }

    func toggleDay(day: Int) {
        self.objectWillChange.send()

        if person.days!.contains(day) {
            person.days!.remove(day)
        } else {
            person.days!.insert(day)
        }
    }
}
