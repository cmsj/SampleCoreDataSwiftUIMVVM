//
//  CEOView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import SwiftUI

struct CEOView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        Section(header: Text("CEO")) {
            NavigationLink(destination: NavigationLazyView(PersonEditor(person: viewModel.ceo, dataManager: viewModel.dataManager)), label: {
            HStack {
                Text("CEO:")
                    .font(.footnote)
                Text(viewModel.ceo.name!)
                    .font(.footnote)
                VStack {
                    HStack {
                        Spacer()
                        Text("(\(viewModel.ceo.reason.rawValue))")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Spacer()
                        Text(viewModel.ceo.daySummary)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
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
