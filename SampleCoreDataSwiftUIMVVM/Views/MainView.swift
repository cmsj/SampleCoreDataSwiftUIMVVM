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
                CEOView(viewModel: viewModel).environment(\.managedObjectContext, viewContext)

                peopleListView(viewModel: viewModel).environment(\.managedObjectContext, viewContext)

                ResetToDefaultsView(viewModel: viewModel).environment(\.managedObjectContext, viewContext)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Peoplr")
        }
        .onAppear {
            self.viewModel.fetchAllPeople()
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
