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
            switch model.appState {
            case .idle:
                IdleView(model: model)

            case .loading:
                LoadingView(condition: model.condition)

            case .success:
                WeatherView(model: model)

            case .error(let message):
                ErrorView(message: message, model: model)
            }
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

// MARK: - Idle View
// Shown briefly before location request fires
struct IdleView: View {
    @Bindable var model: WeatherModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: WeatherCondition.sunny.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("Getting your location")
                    .font(.system(size: 22, weight: .light, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - Loading View
// Shown while API call is in flight
struct LoadingView: View {
    let condition: WeatherCondition

    var body: some View {
        ZStack {
            LinearGradient(
                colors: condition.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.4)

                Text("Fetching weather...")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
}

// MARK: - Error View
// Shown when location is denied or network fails
struct ErrorView: View {
    let message: String
    @Bindable var model: WeatherModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: WeatherCondition.stormy.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Image(systemName: "exclamationmark.cloud.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("Something went wrong")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)

                Text(message)
                    .font(.system(size: 16, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button {
                    model.requestLocation()
                } label: {
                    Text("Try Again")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.4), lineWidth: 1)
                        )
                }
            }
        }
    }
}
