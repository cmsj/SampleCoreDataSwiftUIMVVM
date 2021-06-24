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
    let viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel).environment(\.managedObjectContext, (viewModel.dataManager).dbHelper.context)
        }
        .onChange(of: scenePhase) { newValue in
            viewModel.save()
        }
    }
}
