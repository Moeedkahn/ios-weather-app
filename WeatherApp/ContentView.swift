//
//  ContentView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 04/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var model = WeatherModel()

    var body: some View {
        ZStack {
//            switch model.appState {
//            case .idle:
//                IdleView(model: model)
//
//            case .loading:
//                LoadingView(condition: model.condition)
//
//            case .success:
//                WeatherView(model: model)
//
//            case .error(let message):
//                ErrorView(message: message, model: model)
//            }
        }
        .animation(.easeInOut(duration: 0.4), value: stateKey)
        .onAppear {
            model.requestLocation()
        }
    }

    // Used to animate transitions between states
    private var stateKey: String {
        switch model.appState {
        case .idle:           return "idle"
        case .loading:        return "loading"
        case .success:        return "success"
        case .error:          return "error"
        }
    }
}

