//
//  GettingStartedWithTCAApp.swift
//  GettingStartedWithTCA
//
//  Created by Yin Bob on 2025/2/11.
//

import ComposableArchitecture
import SwiftUI

@main
struct GettingStartedWithTCAApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: GettingStartedWithTCAApp .store
            )
        }
    }
}
