//
//  PersonEditor.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct PersonEditor: View {
    @ObservedObject var person: Person

    var body: some View {
        List {
            Section(header: Text("General")) {
                HStack {
                    Text("Name")
                    Spacer()
                    // NOTE: This TextField() is using our Binding extension because bindings normally can't be optionals
                    TextField("", text: $person.name ?? "")
                }
                Picker(selection: $person.reason, label: Text("Visit reason")) {
                    ForEach(VisitReason.allCases) { v in
                        Text(v.rawValue)
                    }
                }
            }
            Section(header: Text("Days")) {
                NavigationLink(destination: DayPicker(person: person), label: {
                    Text("Days")
                    Spacer()
                    Text(person.daySummary)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                })
            }
            Section() {
                DeletePersonButtonView(person: person)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit \(person.isCEO ? "CEO" : "person")")
    }
}

struct PersonEditor_Previews: PreviewProvider {
    static let dataManager = DataManager.shared
    static let people = dataManager.fetchPeople(ceo: false)

    static var previews: some View {
        PersonEditor(person: people.first!)
    }
}
