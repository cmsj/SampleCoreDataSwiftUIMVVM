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
        if !viewModel.person.ceo {
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
                        // Taken from: https://stackoverflow.com/a/57279591/2305249
                        self.presentationMode.wrappedValue.dismiss()

                        // The 0.3 here is a completely magic number that tries to make sure we get back to the main list view right before the delete takes effect and the person animates out of the list.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            viewModel.deletePerson()
                        })
                    },
                    .cancel()
                ])
            }
        }
        }
    }
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
