//
//  PersonEditorViewModel.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import Combine

protocol PersonEditorViewModelProtocol {
    func updatePerson(person: Person)
    func deletePerson(person: Person)
}

class PersonEditorViewModel: ObservableObject {
    var dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
}

extension PersonEditorViewModel: PersonEditorViewModelProtocol {
    func updatePerson(person: Person) {
        dataManager.updatePerson(person: person)
    }

    func deletePerson(person: Person) {
        dataManager.deletePerson(person: person)
    }
}
