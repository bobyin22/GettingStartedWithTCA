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
    
//    func testTimer() async {
//        let store = TestStore(initialState: CounterFeature.State()) {
//            CounterFeature()
//        }
//        
//        await store.send(.toggleTimerButtonTapped) {
//            $0.isTimerRunning = true
//        }
//        
//        await store.receive(\.timerTick) {
//            $0.count = 1
//        }
//        
//        await store.receive(\.timerTick) {
//            $0.count = 2
//        }
//        
//        await store.receive(\.timerTick) {
//            $0.count = 3
//        }
//        
//        await store.send(.toggleTimerButtonTapped) {
//            $0.isTimerRunning = false
//        }
//    }
    
    func numberFact() async {
      let store = TestStore(initialState: CounterFeature.State()) {
        CounterFeature()
      }
        
        await store.send(.factButttonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse, timeout: .seconds(1)) {
            $0.isLoading = false
            $0.fact = "???"
        }
    }
}
