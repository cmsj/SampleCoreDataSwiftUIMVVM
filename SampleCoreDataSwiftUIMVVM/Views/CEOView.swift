//
//  CEOView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI
import CoreData

struct CEOView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var people: FetchedResults<Person>

    init() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "isCEO == true")
        request.sortDescriptors = []
        _people = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        let person: Person? = people.count >= 1 ? people[0] : nil

        Section(header: Text("CEO")) {
            NavigationLink(destination: NavigationLazyView(PersonEditor(person: person!)), label: {
                PersonListItem(person: person!)
            })
        }
    }
}

struct CEOView_Previews: PreviewProvider {
    static var context = DataManager.shared.viewContext

    static var previews: some View {
        List {
            CEOView().environment(\.managedObjectContext, context)
        }
        .listStyle(InsetGroupedListStyle())
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
