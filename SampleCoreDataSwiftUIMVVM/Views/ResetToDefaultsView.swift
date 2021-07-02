//
//  ResetToDefaultsView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct ResetToDefaultsView: View {
    @ObservedObject var dataManager = DataManager.shared
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
            }
            .actionSheet(isPresented: $showingResetAlert) {
                ActionSheet(title: Text("Are you sure?"),
                            message: Text(message),
                            buttons: [
                                .destructive(Text("Reset Peoplr")) { dataManager.restoreDefaults() },
                                .cancel()
                            ])
            }
        }
    }
}

//struct ResetToDefaultsView_Previews: PreviewProvider {
//    static let dataManager = DataManager(inMemory: true)
//
//    static var previews: some View {
//        List {
//            ResetToDefaultsView(viewModel: MainViewModel(dataManager: dataManager))
//        }
//        .listStyle(InsetGroupedListStyle())
//    }
//}
