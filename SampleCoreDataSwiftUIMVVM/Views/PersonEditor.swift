//
//  PersonEditor.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct PersonEditor: View {
    @ObservedObject var viewModel: PersonEditorViewModel

    init(personID: UUID, dataManager: DataManagerBase) {
        viewModel = PersonEditorViewModel(personID: personID, dataManager: dataManager)
    }

    var body: some View {
        List {
            Section(header: Text("General")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("", text: $viewModel.person.name)
                }
                Picker(selection: $viewModel.person.reason, label: Text("Visit reason")) {
                    ForEach(VisitReason.allCases) { v in
                        Text(v.rawValue)
                    }
                }
            }
            Section(header: Text("Days")) {
                NavigationLink(destination: DayPicker(viewModel: viewModel), label: {
                    Text("Days")
                    Spacer()
                    Text(viewModel.person.daySummary)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                })
            }
            Section() {
                DeletePersonButtonView(viewModel: viewModel)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit \(viewModel.person.ceo ? "CEO" : "person")")
    }
}

struct PersonEditor_Previews: PreviewProvider {
    static let dataManager = MockDataManager()
    static let people = dataManager.fetchPeople()

    static var previews: some View {
        PersonEditor(personID: people.first!.id, dataManager: dataManager)
    }
}
