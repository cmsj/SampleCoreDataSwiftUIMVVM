//
//  Model Extensions.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 31/07/2020.
//

import Foundation

extension PersonMO {
    func convertToPerson() -> Person {
        Person(id: uuid ?? UUID(),
               ceo: isCEO,
               name: name ?? "UNKNOWN",
               reason: VisitReason(rawValue: reason ?? "Unknown") ?? .Unknown,
               daysAllowed: days ?? Set<Int>()
        )
    }
}
