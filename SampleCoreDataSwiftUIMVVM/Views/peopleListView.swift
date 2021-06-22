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
                // In current Xcode 12 betas, NavigationLink() doesn't seem to consistently load destinations lazily
                // so we're forcing it to, see NavigationLazyView.swift
                NavigationLink(destination: NavigationLazyView(PersonEditor(person: person, dataManager: viewModel.dataManager)), label: {
                    HStack {
                        Text(person.name!)
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
                viewModel.deletePeopleAtOffsets(indexSet: indexSet)
                viewModel.fetchNormalPeople()
            }

            Button("Add person...") {
                withAnimation {
                    viewModel.newPerson()
                    viewModel.fetchNormalPeople()
                }
            }
        }
    }
}

struct peopleListView_Previews: PreviewProvider {
    init() {
        let _ = CoreDataHelper.shared.context
        DataManager.shared.restoreDefaults()
    }

    static var previews: some View {
        let context = CoreDataHelper.shared.context

        List {
            peopleListView(viewModel: MainViewModel()).environment(\.managedObjectContext, context)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
