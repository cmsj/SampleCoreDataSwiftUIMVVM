//
//  ResetToDefaultsView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct ResetToDefaultsView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingResetAlert = false

    let message = "This will erase all people and restore the defaults"

    var body: some View {
        Section() {
            Button(action: { self.showingResetAlert = true }) {
                HStack {
                    Spacer()
                    Text("Reset to defaults")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }.actionSheet(isPresented: $showingResetAlert) {
                ActionSheet(title: Text("Are you sure?"),
                            message: Text(message),
                            buttons: [
                                .destructive(Text("Reset Peoplr")) {
                                    viewModel.resetToDefaults()
                                    viewModel.fetchAllPeople()
                                },
                                .cancel()
                            ])
            }
        }
    }
}

struct ResetToDefaultsView_Previews: PreviewProvider {
    init() {
        let _ = CoreDataHelper.shared.context
        DataManager.shared.restoreDefaults()
    }

    static var previews: some View {
        let context = CoreDataHelper.shared.context

        List {
            ResetToDefaultsView(viewModel: MainViewModel()).environment(\.managedObjectContext, context)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
