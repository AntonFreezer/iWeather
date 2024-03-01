//
//  City.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import Foundation
import CoreLocation

struct City: Hashable {

    var name: String
    var date: String
    var timezoneIdentifier: String
    var currentTemp: String
    var condition: String
    var hours: [WeatherPerHour]
        
    static let citiesWithLocations: [String: CLLocation] = [
        "Moscow":           CLLocation(latitude: 55.7558, longitude: 37.6173),
        "Saint Petersburg": CLLocation(latitude: 59.9343, longitude: 30.3351),
        "Novosibirsk":      CLLocation(latitude: 55.0084, longitude: 82.9357),
        "Yekaterinburg":    CLLocation(latitude: 56.8389, longitude: 60.6057),
        "Kazan":            CLLocation(latitude: 55.8304, longitude: 49.0661),
        "Nizhny Novgorod":  CLLocation(latitude: 56.2965, longitude: 43.9361),
        "Chelyabinsk":      CLLocation(latitude: 55.1644, longitude: 61.4368),
        "Samara":           CLLocation(latitude: 53.2028, longitude: 50.1408),
        "Omsk":             CLLocation(latitude: 54.9885, longitude: 73.3242),
        "Rostov-on-Don":    CLLocation(latitude: 47.2225, longitude: 39.7188)
    ]
}


