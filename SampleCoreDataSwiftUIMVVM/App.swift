//
//  App.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 24/06/2021.
//

import SwiftUI

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
            print("scenePhase changed")
            dataManager.save()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let dataManager = DataManager.shared
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: dataManager.viewContext,
                                               queue: nil) { notification in
            print("NSManagedObjectCOntextObjectsDidChange fired")
            DataManager.shared.save()
        }

        return true
    }
}
