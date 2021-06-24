//
//  MainView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List() {
                CEOView()

                PeopleListView()

                ResetToDefaultsView(viewModel: viewModel)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Peoplr")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let dataManager = DataManager(inMemory: true)

    static var previews: some View {
        MainView(viewModel: MainViewModel(dataManager: dataManager))
.previewInterfaceOrientation(.landscapeLeft)
    }
}
