//
//  MainView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            List() {
                CEOView(viewModel: viewModel)

                peopleListView(viewModel: viewModel)

                ResetToDefaultsView(viewModel: viewModel)
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
