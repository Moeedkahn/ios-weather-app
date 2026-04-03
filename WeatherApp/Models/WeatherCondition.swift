//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import SwiftUI

enum WeatherCondition {
    case sunny
    case partlyCloudy
    case cloudy
    case foggy
    case drizzle
    case rainy
    case snowy
    case stormy

    // MARK: - WMO Weather Code mapping
    // Open-Meteo uses WMO codes — this maps them to our enum
    static func from(code: Int) -> WeatherCondition {
        switch code {
        case 0:                return .sunny
        case 1, 2:             return .partlyCloudy
        case 3:                return .cloudy
        case 45, 48:           return .foggy
        case 51, 53, 55:       return .drizzle
        case 61, 63, 65,
             80, 81, 82:       return .rainy
        case 71, 73, 75,
             77, 85, 86:       return .snowy
        case 95, 96, 99:       return .stormy
        default:               return .cloudy
        }
    }

    // MARK: - SF Symbol
    var icon: String {
        switch self {
        case .sunny:        return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy:       return "cloud.fill"
        case .foggy:        return "cloud.fog.fill"
        case .drizzle:      return "cloud.drizzle.fill"
        case .rainy:        return "cloud.heavyrain.fill"
        case .snowy:        return "cloud.snow.fill"
        case .stormy:       return "cloud.bolt.rain.fill"
        }
    }

    // MARK: - Description
    var description: String {
        switch self {
        case .sunny:        return "Sunny"
        case .partlyCloudy: return "Partly Cloudy"
        case .cloudy:       return "Cloudy"
        case .foggy:        return "Foggy"
        case .drizzle:      return "Drizzle"
        case .rainy:        return "Rainy"
        case .snowy:        return "Snowy"
        case .stormy:       return "Stormy"
        }
    }

    // MARK: - Dynamic gradient (this drives the whole UI theme)
    var gradientColors: [Color] {
        switch self {
        case .sunny:
            return [
                Color(hex: "FF9500"),
                Color(hex: "FFCC02"),
                Color(hex: "FF6B00")
            ]
        case .partlyCloudy:
            return [
                Color(hex: "4A90D9"),
                Color(hex: "87CEEB"),
                Color(hex: "B0C4DE")
            ]
        case .cloudy:
            return [
                Color(hex: "636E72"),
                Color(hex: "B2BEC3"),
                Color(hex: "4A5568")
            ]
        case .foggy:
            return [
                Color(hex: "8E9EAB"),
                Color(hex: "BDC3C7"),
                Color(hex: "6B7B8D")
            ]
        case .drizzle:
            return [
                Color(hex: "2C3E6B"),
                Color(hex: "4A6FA5"),
                Color(hex: "6B8CBE")
            ]
        case .rainy:
            return [
                Color(hex: "1A2A4A"),
                Color(hex: "2C3E6B"),
                Color(hex: "34495E")
            ]
        case .snowy:
            return [
                Color(hex: "A8D8EA"),
                Color(hex: "DDEEFF"),
                Color(hex: "7FB3D3")
            ]
        case .stormy:
            return [
                Color(hex: "1A1A2E"),
                Color(hex: "2D1B4E"),
                Color(hex: "16213E")
            ]
        }
    }

    // MARK: - Card background (slightly transparent overlay on gradient)
    var cardColor: Color {
        switch self {
        case .sunny, .partlyCloudy:
            return Color.white.opacity(0.25)
        case .snowy, .foggy:
            return Color.white.opacity(0.2)
        default:
            return Color.white.opacity(0.15)
        }
    }

    // MARK: - Text color (dark text on light conditions, white on dark)
    var primaryTextColor: Color {
        switch self {
        case .sunny, .snowy, .foggy, .partlyCloudy:
            return Color(hex: "1A1A1A")
        default:
            return Color.white
        }
    }

    var secondaryTextColor: Color {
        switch self {
        case .sunny, .snowy, .foggy, .partlyCloudy:
            return Color(hex: "1A1A1A").opacity(0.6)
        default:
            return Color.white.opacity(0.7)
        }
    }
}

// MARK: - Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
