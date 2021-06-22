//
//  PersonEditor.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct PersonEditor: View {
    @ObservedObject var viewModel: PersonEditorViewModel

    init(person: Person, dataManager: DataManagerBase) {
        viewModel = PersonEditorViewModel(person: person, dataManager: dataManager)
    }

    var body: some View {
        List {
            Section(header: Text("General")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("", text: $viewModel.person.name ?? "")
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
        .navigationTitle("Edit \(viewModel.person.isCEO ? "CEO" : "person")")
    }
}

struct PersonEditor_Previews: PreviewProvider {
    static let dataManager = DataManager(inMemory: true)
    static let people = dataManager.fetchPeople()

    static var previews: some View {
        PersonEditor(person: people.first!, dataManager: dataManager)
    }
}
