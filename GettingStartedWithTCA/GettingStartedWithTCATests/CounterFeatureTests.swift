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
    func testTimer() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        await store.receive(\.timerTick) {
            $0.count = 2
        }
        
        await store.receive(\.timerTick) {
            $0.count = 3
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
//    func basics() async {
//        let store = TestStore(initialState: CounterFeature.State()) {
//            CounterFeature()
//        }
//        
//        await store.send(.incrementButtonTapped) {
//            $0.count = 1
//        }
//        await store.send(.decrementButtonTapped) {
//            $0.count = 0
//        }
//    }
}
