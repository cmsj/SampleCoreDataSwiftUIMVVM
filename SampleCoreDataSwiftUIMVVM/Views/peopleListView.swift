//
//  peopleListView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI
import CoreData

struct PeopleListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)], predicate: NSPredicate(format: "isCEO == false")) var people: FetchedResults<Person>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Section(header: Text("People"), footer: Text("Swipe to delete")) {
            ForEach(people) { person in
                // In current Xcode 12 betas, NavigationLink() doesn't seem to consistently load destinations lazily
                // so we're forcing it to, see NavigationLazyView.swift
                NavigationLink(destination: NavigationLazyView(PersonEditor(person: person)), label: {
                    PersonListItem(person: person)
                })
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.map { people[$0] }.forEach(viewContext.delete)
                }
            }

            Button("Add person...") {
                withAnimation {
                    let newPerson = Person(context: viewContext)
                    newPerson.uuid = UUID()
                    newPerson.name = "Newy Newerson"
                    newPerson.isCEO = false
                    newPerson.reason = .SummerVacation
                    newPerson.days = Set(0..<7)
                }
            }
        }
    }
}

struct peopleListView_Previews: PreviewProvider {
    static let dataManager = DataManager(inMemory: true)

    static var previews: some View {
        List {
            PeopleListView()
        }
        .listStyle(InsetGroupedListStyle())
    }
}
