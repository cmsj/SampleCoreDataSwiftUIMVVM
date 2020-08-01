//
//  PersonEditor.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct PersonEditor: View {
    @ObservedObject var viewModel: PersonEditorViewModel
    @State var person: Person
    @State var updateTrigger = 1 // This is an ugly hack

    var name: Binding<String> { Binding(
        get: { person.name },
        set: {
            person.name = $0
            viewModel.updatePerson(person: person)
            updateTrigger += 1
        }
    )}

    var reason: Binding<VisitReason> { Binding(
        get: { person.reason },
        set: {
            person.reason = $0
            viewModel.updatePerson(person: person)
            updateTrigger += 1
        }
    )}

    var body: some View {
        List {
            Section(header: Text("General")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("", text: name)
                }
                Picker(selection: reason, label: Text("Visit reason")) {
                    ForEach(VisitReason.allCases) { v in
                        Text(v.rawValue)
                    }
                }
            }
            Section(header: Text("Days")) {
                NavigationLink(destination: DayPicker(viewModel: viewModel, person: person), label: {
                    Text("Days")
                    Spacer()
                    Text(person.daySummary)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                })
            }
            Section() {
                DeletePersonButtonView(viewModel: viewModel, person: person)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit person")
    }
}

/*
 struct PersonEditor_Previews: PreviewProvider {
 static var previews: some View {
 PersonEditor()
 }
 }
 */
