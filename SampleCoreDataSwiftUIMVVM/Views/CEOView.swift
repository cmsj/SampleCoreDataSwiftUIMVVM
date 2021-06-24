//
//  CEOView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI
import CoreData

struct CEOView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var people: FetchedResults<Person>

//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)], predicate: NSPredicate(format: "isCEO == true")) var people: FetchedResults<Person>

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "isCEO == true")
        request.sortDescriptors = []
        _people = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        let person: Person? = people.count >= 1 ? people[0] : nil

        Section(header: Text("CEO")) {
            NavigationLink(destination: NavigationLazyView(PersonEditor(person: viewModel.ceo, dataManager: viewModel.dataManager)), label: {
                PeopleListViewItem(for: person?.uuid! ?? UUID())

            })
        }
    }
}

struct CEOView_Previews: PreviewProvider {
    static let dataManager = DataManager(inMemory: true)

    static var previews: some View {
        List {
            CEOView(viewModel: MainViewModel(dataManager: dataManager))
        }
        .listStyle(InsetGroupedListStyle())
.previewInterfaceOrientation(.landscapeLeft)
    }
}
