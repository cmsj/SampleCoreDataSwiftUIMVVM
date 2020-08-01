//
//  peopleListView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct peopleListView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        Section(header: Text("People"), footer: Text("Swipe to delete")) {
            ForEach(viewModel.people) { person in
                NavigationLink(destination: PersonEditor(person: person, dataManager: viewModel.dataManager), label: {
                    HStack {
                        Text(person.name)
                        Spacer()
                        VStack {
                            HStack {
                                Spacer()
                                Text("(\(person.reason.rawValue))")
                                    .font(.footnote)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Spacer()
                                Text(person.daySummary)
                                    .font(.footnote)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                })
            }
            .onDelete { indexSet in
                for index in indexSet {
                    // We seem to be mutating the dataset while we're iterating it.
                    // That seems like a bad idea. Can onDelete swipes ever come in multiples?
                    let person = viewModel.people[index]
                    viewModel.deletePerson(person: person)
                    viewModel.fetchNormalPeople()
                }
            }

            Button("Add person...") {
                viewModel.newPerson()
                viewModel.fetchNormalPeople()
            }
        }
    }
}

struct peopleListView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            peopleListView(viewModel: MainViewModel(dataManager: MockDataManager()))
        }
        .listStyle(InsetGroupedListStyle())
    }
}
