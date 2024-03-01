//
//  WeatherPerHour.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import Foundation

struct WeatherPerHour: Hashable {
    var hour: String
    var isCurrentHour: Bool
    var currentTemp: String
    var iconName: String
}

