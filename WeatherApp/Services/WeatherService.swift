//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import Foundation
import CoreLocation
enum WeatherError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Something went wrong building the request."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Could not read weather data. Please try again."
        case .noData:
            return "No weather data received."
        }
    }
}
struct WeatherService {
    // MARK: - Base URL components
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    private let currentParams = [
        "temperature_2m",
        "weathercode",
        "windspeed_10m",
        "relativehumidity_2m"
    ].joined(separator: ",")
    private let hourlyParams = [
        "temperature_2m",
        "weathercode"
    ].joined(separator: ",")
    private let dailyParams = [
        "weathercode",
        "temperature_2m_max",
        "temperature_2m_min"
    ].joined(separator: ",")

    // MARK: - Main fetch function
    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "latitude",  value: String(lat)),
            URLQueryItem(name: "longitude", value: String(lon)),
            URLQueryItem(name: "current",   value: currentParams),
            URLQueryItem(name: "hourly",    value: hourlyParams),
            URLQueryItem(name: "daily",     value: dailyParams),
            URLQueryItem(name: "timezone",  value: "auto"),
            URLQueryItem(name: "forecast_days", value: "7")
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw WeatherError.networkError(error)
        }

        // Check HTTP status code
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw WeatherError.noData
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            throw WeatherError.decodingError(error)
        }
    }

    // MARK: - Reverse geocoding (coordinates → city name)
    func cityName(for location: CLLocation) async -> String {
        let geocoder = CLGeocoder()
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        return placemarks?.first?.locality ?? "Unknown Location"
    }

    // MARK: - Parse hourly forecasts (next 24 hours only)
    func parseHourly(from response: WeatherResponse) -> [HourlyForecast] {
        let hourly = response.hourly
        let now = Date()
        let calendar = Calendar.current

        return zip(zip(hourly.time, hourly.temperature), hourly.weatherCode)
            .compactMap { (timeTemp, code) -> HourlyForecast? in
                let (timeString, temp) = timeTemp

                guard let date = parseDate(timeString) else { return nil }
                guard date >= now else { return nil }

                let hour = calendar.component(.hour, from: date)
                let label = hour == calendar.component(.hour, from: now)
                    ? "Now"
                    : formatHour(date)

                return HourlyForecast(
                    time:        label,
                    temperature: temp,
                    condition:   WeatherCondition.from(code: code)
                )
            }
            .prefix(24)
            .map { $0 }
    }

    // MARK: - Parse daily forecasts
    func parseDaily(from response: WeatherResponse) -> [DailyForecast] {
        let daily = response.daily

        return zip(zip(daily.time, daily.weatherCode),
                   zip(daily.maxTemperature, daily.minTemperature))
            .enumerated()
            .map { index, zipped in
                let ((timeString, code), (maxTemp, minTemp)) = zipped
                let day = index == 0 ? "Today" : dayName(from: timeString)
                return DailyForecast(
                    day:       day,
                    condition: WeatherCondition.from(code: code),
                    maxTemp:   maxTemp,
                    minTemp:   minTemp
                )
            }
    }
    // MARK: - Date helpers
    private func parseDate(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        return formatter.date(from: string)
    }
    private func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date).lowercased()
    }
    private func dayName(from string: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: string) else { return string }
        let output = DateFormatter()
        output.dateFormat = "EEEE"
        return output.string(from: date)
    }
}
