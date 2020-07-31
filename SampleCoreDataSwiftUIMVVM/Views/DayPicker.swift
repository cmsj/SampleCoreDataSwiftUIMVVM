//
//  DayPicker.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct CheckmarkTextRow: View {
    @State var person: Person

    var title: String
    var index: Int
    var isSelected: Bool {
        person.daysAllowed.contains(index)
    }

    var body: some View {
        Button(action: {
            if person.daysAllowed.contains(index) {
                person.daysAllowed.remove(index)
            } else {
                person.daysAllowed.insert(index)
            }
        }) {
            HStack {
                Text(self.title)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(self.isSelected ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2))
            }
        }
    }
}

struct DayPicker: View {
    @ObservedObject var viewModel: PersonEditorViewModel
    @State var person: Person

    @State var trigger = 1 // This is a hack

    let calendar = Calendar.current

    var body: some View {
        List(0 ..< 7) { index in
            CheckmarkTextRow(person: person, title: calendar.weekdaySymbols[index], index: index)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Days")    }
}

/*
struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        DayPicker()
    }
}
*/
