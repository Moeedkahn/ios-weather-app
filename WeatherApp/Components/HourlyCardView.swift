//
//  HourlyCardView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

struct HourlyCardView: View {
    let forecast:  HourlyForecast
    let condition: WeatherCondition

    var body: some View {
        VStack(spacing: 8) {
            Text(forecast.time)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(condition.secondaryTextColor)

            Image(systemName: forecast.condition.icon)
                .font(.system(size: 22))
                .foregroundStyle(condition.primaryTextColor)

            Text("\(Int(forecast.temperature.rounded()))°")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(condition.primaryTextColor)
        }
        .frame(width: 64)
        .padding(.vertical, 16)
        .background(condition.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
