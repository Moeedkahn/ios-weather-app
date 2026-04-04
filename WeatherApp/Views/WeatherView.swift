//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

struct WeatherView: View {
    @Bindable var model: WeatherModel

    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                colors: model.condition.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.8), value: model.condition.description)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.top, 60)

                    currentWeatherSection
                        .padding(.top, 8)

                    statsSection
                        .padding(.top, 32)

                    hourlySection
                        .padding(.top, 24)

                    dailySection
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                }
            }
            .refreshable {
                model.refresh()
            }
        }
    }

    // MARK: - Header (city name + date)
    private var headerSection: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(model.condition.primaryTextColor.opacity(0.7))

                Text(model.cityName)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(model.condition.primaryTextColor)
            }

            Text(currentDate)
                .font(.system(size: 15, weight: .light, design: .rounded))
                .foregroundStyle(model.condition.secondaryTextColor)
        }
    }

    // MARK: - Current weather (big temperature + icon)
    private var currentWeatherSection: some View {
        VStack(spacing: 0) {
            Image(systemName: model.condition.icon)
                .font(.system(size: 100))
                .foregroundStyle(model.condition.primaryTextColor)
                .symbolEffect(.pulse)
                .padding(.bottom, 8)

            Text(model.temperatureString)
                .font(.system(size: 96, weight: .thin, design: .rounded))
                .foregroundStyle(model.condition.primaryTextColor)

            Text(model.condition.description)
                .font(.system(size: 22, weight: .light, design: .rounded))
                .foregroundStyle(model.condition.secondaryTextColor)
        }
    }

    // MARK: - Stats row (wind + humidity)
    private var statsSection: some View {
        WeatherStatsView(
            windSpeed: model.windSpeedString,
            humidity:  model.humidityString,
            condition: model.condition
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Hourly forecast
    private var hourlySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Hourly Forecast", icon: "clock")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(model.hourlyForecasts) { forecast in
                        HourlyCardView(
                            forecast:  forecast,
                            condition: model.condition
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Daily forecast
    private var dailySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("7-Day Forecast", icon: "calendar")

            VStack(spacing: 2) {
                ForEach(model.dailyForecasts) { forecast in
                    DailyRowView(
                        forecast:  forecast,
                        condition: model.condition
                    )
                }
            }
            .background(model.condition.cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Section header helper
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(model.condition.secondaryTextColor)

            Text(title.uppercased())
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .kerning(0.8)
                .foregroundStyle(model.condition.secondaryTextColor)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Helpers
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}
