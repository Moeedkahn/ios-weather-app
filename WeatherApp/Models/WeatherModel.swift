//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Moeed Khan on 02/04/2026.
//

import Foundation
import CoreLocation
import Observation

enum AppState {
    case idle
    case loading
    case success
    case error(String)
}

@Observable
final class WeatherModel: NSObject {

    // MARK: - App state
    private(set) var appState:        AppState = .idle

    // MARK: - Weather data
    private(set) var cityName:        String = ""
    private(set) var temperature:     Double = 0
    private(set) var condition:       WeatherCondition = .sunny
    private(set) var windSpeed:       Double = 0
    private(set) var humidity:        Double = 0
    private(set) var hourlyForecasts: [HourlyForecast] = []
    private(set) var dailyForecasts:  [DailyForecast] = []

    // MARK: - Location
    private(set) var locationStatus:  CLAuthorizationStatus = .notDetermined

    // MARK: - Private dependencies
    private let service  = WeatherService()
    private let locationManager = CLLocationManager()

    // MARK: - Init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // MARK: - Public interface

    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            appState = .error("Location access denied. Please enable it in Settings.")
        @unknown default:
            break
        }
    }

    func refresh() {
        fetchLocation()
    }

    // MARK: - Private

    private func fetchLocation() {
        appState = .loading
        locationManager.requestLocation()
    }

    private func fetchWeather(for location: CLLocation) {
        Task {
            do {
                async let weatherResponse = service.fetchWeather(for: location)
                async let city            = service.cityName(for: location)

                let (response, name) = try await (weatherResponse, city)

                let current  = response.current
                let hourly   = service.parseHourly(from: response)
                let daily    = service.parseDaily(from: response)

                cityName        = name
                temperature     = current.temperature
                condition       = WeatherCondition.from(code: current.weatherCode)
                windSpeed       = current.windSpeed
                humidity        = current.humidity
                hourlyForecasts = hourly
                dailyForecasts  = daily
                appState        = .success

            } catch let error as WeatherError {
                appState = .error(error.errorDescription ?? "Unknown error")
            } catch {
                appState = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Formatted helpers for Views
    var temperatureString: String {
        "\(Int(temperature.rounded()))°"
    }

    var windSpeedString: String {
        "\(Int(windSpeed.rounded())) km/h"
    }

    var humidityString: String {
        "\(Int(humidity.rounded()))%"
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchWeather(for: location)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        appState = .error("Could not get your location. Please try again.")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            appState = .error("Location access denied. Please enable it in Settings.")
        default:
            break
        }
    }
}
