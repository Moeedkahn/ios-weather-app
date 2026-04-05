//
//  WeatherStatsView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

struct WeatherStatsView: View {
    let windSpeed: String
    let humidity:  String
    let condition: WeatherCondition

    var body: some View {
        HStack(spacing: 12) {
            StatCardView(
                icon:      "wind",
                label:     "Wind",
                value:     windSpeed,
                condition: condition
            )

            StatCardView(
                icon:      "humidity.fill",
                label:     "Humidity",
                value:     humidity,
                condition: condition
            )
        }
    }
}

