//
//  CounterFeatureTests.swift
//  GettingStartedWithTCA
//
//  Created by Yin Bob on 2025/2/13.
//

import ComposableArchitecture
import Testing

@testable import GettingStartedWithTCA

@MainActor
struct CounterFeatureTests {
    @Test
    func basics() async {
        let store = TestStore(initialState: CounterFeature.State()) {
              CounterFeature()
            }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
