//
//  DeletePersonButtonView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct DeletePersonButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var viewModel: PersonEditorViewModel
    @State var person: Person
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
                        viewModel.deletePerson(person: person)
                        // Taken from: https://stackoverflow.com/a/57279591/2305249
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel()
                ])
            }
        }    }
}

/*
struct DeletePersonButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DeletePersonButtonView()
    }
}
*/
