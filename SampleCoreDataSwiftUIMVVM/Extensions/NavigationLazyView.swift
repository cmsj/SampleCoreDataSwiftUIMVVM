//
//  NavigationLazyView.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 02/08/2020.
//

import Foundation
import SwiftUI

// Taken from https://www.objc.io/blog/2019/07/02/lazy-loading/
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
