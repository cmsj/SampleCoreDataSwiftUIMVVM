//
//  DayPicker.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct CheckmarkTextRow: View {
    @ObservedObject var person: Person
    
    var title: String
    var index: Int
    var isSelected: Bool {
        person.hasDay(day: index)
    }
    
    var body: some View {
        Button(action: { person.toggleDay(day: index) }, label: {
            HStack {
                Text(self.title)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(self.isSelected ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: self.isSelected)
            }
        })
    }
}

struct DayPicker: View {
    @ObservedObject var person: Person
    
    let calendar = Calendar.current
    
    var body: some View {
        List(0 ..< 7) { index in
            CheckmarkTextRow(person: person, title: calendar.weekdaySymbols[index], index: index)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Days")
    }
}

//struct DayPicker_Previews: PreviewProvider {
//    static let dataManager = DataManager.init(inMemory: true)
//    static let people = dataManager.fetchPeople()
//
//    static var previews: some View {
//        DayPicker(person: people.first!)
//    }
//}
