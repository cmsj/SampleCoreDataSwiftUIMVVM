//
//  App.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 24/06/2021.
//

import SwiftUI
import os.log

@main
struct SampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    private var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext, dataManager.viewContext)
        }
        .onChange(of: scenePhase) { newValue in
            // Unconditionally save Core Data when we change scene phase (ie the user switches app or hides the app or something)
            Logger.scene.trace("scenePhase changed: \(String(describing: newValue), privacy: .public)")
            dataManager.save()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // NOTE: This is the first point where we fetch DataManager.shared and where it will therefore be instantiated
        Logger.app.trace("Initialising DataManager")
        _ = DataManager.shared

        return true
    }
}
