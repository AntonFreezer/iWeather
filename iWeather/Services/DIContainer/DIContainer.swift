//
//  DIContainer.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import Foundation
import YandexWeatherNetwork

final class DIContainer {
    static let shared = DIContainer()
    
    let yandexWeatherNetworkService: YandexWeatherNetworkClient
    
    init() {
        self.yandexWeatherNetworkService = DefaultYandexWeatherNetworkClient(
            baseURL: "https://api.weather.yandex.ru/v2",
            apiKey: ProcessInfo.processInfo.environment["API_KEY"])
    }
}
