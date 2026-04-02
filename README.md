# iOS Weather App

A dynamic, colorful weather app for iOS that changes its entire 
UI theme based on current weather conditions.

## Status
🚧 In progress

## Planned Features
- Current weather + temperature
- Hourly forecast (next 24hrs)
- 7-day forecast  
- Air quality, humidity, wind speed
- Dynamic UI that changes color with weather condition
- GPS auto-location with CoreLocation

## Tech Stack
- Swift 5.9
- SwiftUI
- CoreLocation
- Open-Meteo API (free, no key required)
- async/await networking
- @Observable MV Pattern
- Swift Testing

## Architecture
MV pattern — same approach as the calculator project. 
WeatherModel is @Observable and owns all state and business logic.
Views observe it directly with no ViewModel layer.

## Project Structure
├── Models/
│   ├── WeatherModel.swift         # @Observable brain, all state lives here
│   ├── WeatherData.swift          # Codable structs matching API response  
│   └── WeatherCondition.swift     # Enum driving the dynamic theme system
├── Views/
│   ├── WeatherView.swift          # Main screen, adapts color by condition
│   ├── HourlyForecastView.swift   # Horizontal scroll, next 24hrs
│   ├── DailyForecastView.swift    # 7-day forecast list
│   └── WeatherStatsView.swift     # Humidity, wind, air quality cards
├── Components/
│   ├── HourlyCardView.swift       # Single hour card
│   ├── DailyRowView.swift         # Single day row
│   └── StatCardView.swift         # Single stat card
└── Services/
    └── WeatherService.swift       # async/await API calls