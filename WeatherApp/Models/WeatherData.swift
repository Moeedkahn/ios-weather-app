//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import Foundation

// MARK: - Root response
struct WeatherResponse: Codable {
    let current:  CurrentWeather
    let hourly:   HourlyWeather
    let daily:    DailyWeather
}

// MARK: - Current weather
struct CurrentWeather: Codable {
    let temperature:  Double
    let weatherCode:  Int
    let windSpeed:    Double
    let humidity:     Double

    enum CodingKeys: String, CodingKey {
        case temperature  = "temperature_2m"
        case weatherCode  = "weathercode"
        case windSpeed    = "windspeed_10m"
        case humidity     = "relativehumidity_2m"
    }
}

// MARK: - Hourly forecast
struct HourlyWeather: Codable {
    let time:         [String]
    let temperature:  [Double]
    let weatherCode:  [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature  = "temperature_2m"
        case weatherCode  = "weathercode"
    }
}

// MARK: - Daily forecast
struct DailyWeather: Codable {
    let time:           [String]
    let weatherCode:    [Int]
    let maxTemperature: [Double]
    let minTemperature: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode    = "weathercode"
        case maxTemperature = "temperature_2m_max"
        case minTemperature = "temperature_2m_min"
    }
}

// MARK: - Clean models for Views to consume
// These are what views actually use — converted from raw API structs above

struct HourlyForecast: Identifiable {
    let id    = UUID()
    let time:        String      // "14:00"
    let temperature: Double
    let condition:   WeatherCondition
}

struct DailyForecast: Identifiable {
    let id    = UUID()
    let day:         String      // "Monday"
    let condition:   WeatherCondition
    let maxTemp:     Double
    let minTemp:     Double
}
