//
//  App.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 24/06/2021.
//

import SwiftUI

@main
struct SampleApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext, dataManager.viewContext)
        }
        .onChange(of: scenePhase) { newValue in
            dataManager.save()
        }
    }
}
