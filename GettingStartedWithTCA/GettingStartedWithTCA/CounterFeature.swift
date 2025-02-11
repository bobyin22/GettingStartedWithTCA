//
//  CounterFeature.swift
//  GettingStartedWithTCA
//
//  Created by Yin Bob on 2025/2/11.
//

import ComposableArchitecture
import SwiftUI

/*
 用戶操作 → Action → Reducer → State 更新 → 視圖更新
                   ↳ Effect → Action → Reducer
 */

//MARK: - 核心功能部分
@Reducer // 這就像是一個管理員，負責管理所有的動作和狀態
struct CounterFeature {
    
    // 1. 狀態 (State) - 就像是一個容器，存放所有數據
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    //MARK: - 所有可能的操作
    // 就像遙控器上的按鈕，每個按鈕都做不同的事
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetButtonTapped
        case factButttonTapped
        case factResponse(fact: String) // 收到趣味知識的回應
        case toggleTimerButtonTapped
        case timerTick
    }
    
    // 用來標識計時器的ID，方便控制它
    enum CancelID { case timer }
    
    //MARK: - 核心邏輯處理
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .resetButtonTapped:
                state.count = 0
                state.fact = nil
                return .none
            case .factButttonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    // ✅ Do async work in here, and send actions back into the system.
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    
                    await send(.factResponse(fact: fact))
                }
            case let .factResponse(fact: fact):
                state.isLoading = false
                state.fact = fact
                return .none
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
                
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}

extension CounterFeature.State: Equatable {}

//MARK: - 畫面部分
struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack{
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("Reset") {
                        viewStore.send(.resetButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
                    viewStore.send(.toggleTimerButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("Fact") {
                    viewStore.send(.factButttonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}


struct CounterPreview: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(initialState:
                CounterFeature.State()) {
                //CounterFeature()
            }
        )
    }
}
