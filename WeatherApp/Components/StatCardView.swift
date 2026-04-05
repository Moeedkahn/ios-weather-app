//
//  StatCardView.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

struct StatCardView: View {
    let icon:      String
    let label:     String
    let value:     String
    let condition: WeatherCondition

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(condition.primaryTextColor.opacity(0.8))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(label.uppercased())
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .kerning(0.6)
                    .foregroundStyle(condition.secondaryTextColor)

                Text(value)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(condition.primaryTextColor)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(condition.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
