//
//  DayPicker.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct CheckmarkTextRow: View {
    @ObservedObject var viewModel: PersonEditorViewModel
    
    var title: String
    var index: Int
    var isSelected: Bool {
        // This (and the ones below) feel like we're reaching too deep.
        // PersonEditorViewModel should probably abstract this somewhat
        viewModel.person.daysAllowed.contains(index)
    }
    
    var body: some View {
        Button(action: {
            if viewModel.person.daysAllowed.contains(index) {
                viewModel.person.daysAllowed.remove(index)
            } else {
                viewModel.person.daysAllowed.insert(index)
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
    
    let calendar = Calendar.current
    
    var body: some View {
        List(0 ..< 7) { index in
            CheckmarkTextRow(viewModel: viewModel, title: calendar.weekdaySymbols[index], index: index)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Days")
    }
}

struct DayPicker_Previews: PreviewProvider {
    static let dataManager = MockDataManager()
    static let people = dataManager.fetchPeople()
    
    static var previews: some View {
        DayPicker(viewModel: PersonEditorViewModel(personID: people.first!.id, dataManager: dataManager))
    }
}
