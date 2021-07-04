//
//  LogManager.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 04/07/2021.
//

import Foundation
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let dataManager = Logger(subsystem: subsystem, category: "dataManager")
    static let dbHelper = Logger(subsystem: subsystem, category: "dbHelper")
    static let scene = Logger(subsystem: subsystem, category: "Scene")
}
