//
//  peopleListView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI
import CoreData

struct PeopleListViewItem: View {
    @FetchRequest var people: FetchedResults<Person>
    @Environment(\.managedObjectContext) private var viewContext

    init(for personID: UUID) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", personID as CVarArg)
        request.sortDescriptors = []
        _people = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        // Person has to be optional here because during a delete we will be refreshed, but the data might not exist anymore
        let person: Person? = people.count >= 1 ? people[0] : nil

        HStack {
            Text(person?.name! ?? "no person")
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Text("(\(person?.reason.rawValue ?? "no reason"))")
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Spacer()
                    Text(person?.daySummary ?? "no summary")
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}

struct peopleListView: View {
    @ObservedObject var viewModel: MainViewModel
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)], predicate: NSPredicate(format: "isCEO == false")) var people: FetchedResults<Person>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Section(header: Text("People"), footer: Text("Swipe to delete")) {
            ForEach(people) { person in
                // In current Xcode 12 betas, NavigationLink() doesn't seem to consistently load destinations lazily
                // so we're forcing it to, see NavigationLazyView.swift
                NavigationLink(destination: NavigationLazyView(PersonEditor(person: person, dataManager: viewModel.dataManager)), label: {
                    PeopleListViewItem(for: person.uuid!)
                })
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.map { people[$0] }.forEach(viewContext.delete)
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
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

                    do{
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
}

struct peopleListView_Previews: PreviewProvider {
    static let dataManager = DataManager(inMemory: true)

    static var previews: some View {
        List {
            peopleListView(viewModel: MainViewModel(dataManager: dataManager))
        }
        .listStyle(InsetGroupedListStyle())
    }
}
