//
//  PersonListItem.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 25/06/2021.
//

import SwiftUI

struct PersonListItem: View {
    @ObservedObject var person: Person

    var body: some View {
        HStack {
            Text(person.name ?? "Unknown")
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
    }
}

struct PersonListItem_Previews: PreviewProvider {
    static let dataManager = DataManager.shared
    static let people = dataManager.fetchPeople(ceo: false)

    static var previews: some View {
        List {
            PersonListItem(person: people.first!)
        }
    }
}
