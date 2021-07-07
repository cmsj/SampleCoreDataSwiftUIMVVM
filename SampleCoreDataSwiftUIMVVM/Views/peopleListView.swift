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
                // NavigationLink is not fully lazy, so we've implemented that ourselves. See NavigationLazyView.swift
                NavigationLink(destination: NavigationLazyView(PersonEditor(person: person)), label: {
                    PersonListItem(person: person)
                })
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.map { people[$0] }.forEach(DataManager.shared.deletePerson)
                }
            }

            Button("Add person...") {
                withAnimation {
                    DataManager.shared.addPerson(name: "Newy Newerson", ceo: false, visitReason: .SummerVacation, days: Set(0..<7))
                }
            }
        }
    }
}

struct peopleListView_Previews: PreviewProvider {
    static var context = DataManager.shared.viewContext

    static var previews: some View {
        List {
            PeopleListView().environment(\.managedObjectContext, context)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
