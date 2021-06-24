//
//  MainViewModel.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @ObservedObject var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    func resetToDefaults() {
        dataManager.restoreDefaults()
    }

    func save() {
        if dataManager.dbHelper.context.hasChanges {
            print("Saving!")
            dataManager.dbHelper.saveContext()
        }
    }
}
