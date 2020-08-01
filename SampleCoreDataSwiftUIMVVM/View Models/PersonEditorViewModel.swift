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
}
