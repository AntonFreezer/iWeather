//
//  City.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import Foundation

struct City: Hashable {
    
    enum Condition: String, CaseIterable {
        case clear = "Clear"
        case partlyCloudy = "Partly Cloudy"
        case cloudy = "Cloudy"
        case overcast = "Overcast"
        case lightRain = "Light Rain"
        case rain = "Rain"
        case heavyRain = "Heavy Rain"
        case showers = "Showers"
        case wetSnow = "Wet Snow"
        case lightSnow = "Light Snow"
        case snow = "Snow"
        case snowShowers = "Snow Showers"
        case hail = "Hail"
        case thunderstorm = "Thunderstorm"
        case thunderstormWithRain = "Thunderstorm With Rain"
        case thunderstormWithHail = "Thunderstorm With Hail"
        
        func localized() -> String {
            let resource = LocalizedStringResource(stringLiteral: self.rawValue)
            return String(localized: resource)
        }
    }

    var name: String
    var date: String
    var timezoneIdentifier: String
    var currentTemp: String
    var condition: Condition
    var hours: [WeatherPerHour]
    
    static let mockCities: [City] = generateMockCities()
    
    private static func generateMockCities() -> [City] {
        let cities = ["Moscow", "Saint Petersburg", "Novosibirsk", "Yekaterinburg", "Kazan", "Nizhny Novgorod", "Chelyabinsk", "Samara", "Omsk", "Rostov-on-Don"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        
        let iconURL =
    "https://yastatic.net/weather/i/icons/funky/dark/"
        
        return cities.map { city in
            City(name: city,
                 date: todayDate,
                 timezoneIdentifier: "Europe/Moscow",
                 currentTemp: "\(Int.random(in: -5...25))",
                 condition: Condition.allCases.randomElement()!,
                 hours: (0..<24).map { hour in
                WeatherPerHour(hour: "\(hour)",
                              currentTemp: "\(Int.random(in: -5...25))",
                              iconURL: iconURL + ["bkn_n", "skc_d", "ovc"].randomElement()! + ".svg")
            })
        }
    }
}


