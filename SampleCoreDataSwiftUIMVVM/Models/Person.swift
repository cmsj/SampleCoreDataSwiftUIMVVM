//
//  Person.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation

public enum VisitReason: String, CaseIterable, Identifiable {
    public var id: VisitReason { self }

    case SummerVacation = "Summer Vacation"
    case Corp = "Corporate"
    case Staff
    case Unknown
}

struct Person: Identifiable, Equatable {
    var id: UUID = UUID()
    var ceo: Bool = false
    var name: String = "Unknown"
    var reason: VisitReason = .Unknown
    var daysAllowed: Set<Int> = Set<Int>()
}

extension Person {
    var daySummary: String {
        get {
            if self.daysAllowed == Set() {
                return "None"
            }
            if self.daysAllowed == Set(0..<7) {
                return "Every day"
            }
            if self.daysAllowed == Set(1..<6) {
                return "Weekdays"
            }

            let dayLabels = DateFormatter().shortStandaloneWeekdaySymbols
            var summaryParts: [String] = []
            for (index, day) in dayLabels!.enumerated() {
                if self.daysAllowed.contains(index) {
                    summaryParts.append(day)
                }
            }
            return summaryParts.joined(separator: ", ")
        }
    }
}
