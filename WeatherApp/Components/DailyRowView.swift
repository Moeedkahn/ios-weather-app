//
//  DailyRowView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

struct DailyRowView: View {
    let forecast:  DailyForecast
    let condition: WeatherCondition

    var body: some View {
        HStack(spacing: 0) {
            // Day name
            Text(forecast.day)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundStyle(condition.primaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Weather icon
            Image(systemName: forecast.condition.icon)
                .font(.system(size: 20))
                .foregroundStyle(condition.primaryTextColor.opacity(0.85))
                .frame(width: 36)

            // Temp range
            HStack(spacing: 6) {
                Text("\(Int(forecast.minTemp.rounded()))°")
                    .font(.system(size: 17, weight: .light, design: .rounded))
                    .foregroundStyle(condition.secondaryTextColor)
                    .frame(width: 40, alignment: .trailing)

                // Temp range bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(condition.primaryTextColor.opacity(0.15))
                            .frame(height: 4)

                        Capsule()
                            .fill(condition.primaryTextColor.opacity(0.7))
                            .frame(
                                width: geo.size.width * tempRatio,
                                height: 4
                            )
                    }
                }
                .frame(width: 60, height: 4)
                .padding(.vertical, 10)

                Text("\(Int(forecast.maxTemp.rounded()))°")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(condition.primaryTextColor)
                    .frame(width: 40, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.clear)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(condition.primaryTextColor.opacity(0.08))
                .frame(height: 0.5)
                .padding(.horizontal, 20)
        }
    }

    // Ratio of min→max within a realistic temperature range
    private var tempRatio: CGFloat {
        let range = forecast.maxTemp - forecast.minTemp
        let scale = max(range / 20.0, 0.15)
        return min(CGFloat(scale), 1.0)
    }
}
