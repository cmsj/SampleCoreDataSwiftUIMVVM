//
//  MainView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List() {
                CEOView()

                PeopleListView()

                ResetToDefaultsView()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Peoplr")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var context = DataManager.shared.viewContext

    static var previews: some View {
        MainView().environment(\.managedObjectContext, context)
.previewInterfaceOrientation(.landscapeLeft)
    }
}
