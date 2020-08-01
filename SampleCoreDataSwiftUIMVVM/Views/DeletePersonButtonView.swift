//
//  DeletePersonButtonView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct DeletePersonButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: PersonEditorViewModel
    @State private var showingDeleteAlert = false

    var body: some View {
        Section() {
            Button(action: { self.showingDeleteAlert = true }) {
                HStack {
                    Spacer()
                    Text("Delete Person")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }.actionSheet(isPresented: $showingDeleteAlert) {
                ActionSheet(title: Text("Are you sure?"), message: Text("This person will be removed"), buttons: [
                    .destructive(Text("Delete")) {
                        // FIXME: Why are we telling our view model to delete the (only) person it owns? This is a smell
                        viewModel.deletePerson()
                        // Taken from: https://stackoverflow.com/a/57279591/2305249
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel()
                ])
            }
        }    }
}

struct DeletePersonButtonView_Previews: PreviewProvider {
    static let dataManager = MockDataManager()
    static let people = dataManager.fetchPeople()

    static var previews: some View {
        List() {
            DeletePersonButtonView(viewModel: PersonEditorViewModel(personID: people.first!.id, dataManager: dataManager))
        }
        .listStyle(InsetGroupedListStyle())
    }
}
