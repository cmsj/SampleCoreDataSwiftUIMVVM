//
//  Binding.swift
//  SampleCoreDataSwiftUIMVVM
//
//  Created by Chris Jones on 22/06/2021.
//

import Foundation
import SwiftUI

// This is used to deal with bindings of properties on Core Data objects, which Xcode always generates as optionals
func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
  return Binding(get: {
    binding.wrappedValue ?? fallback
  }, set: {
    binding.wrappedValue = $0
  })
}
