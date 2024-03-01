//
//  YandexWeatherNetworkForecastsEntity.swift
//  YandexWeatherNetwork
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import Foundation

public struct YandexWeatherNetworkForecastsEntity: Decodable, Hashable {
    public let now: Int
    public let nowDt: String
    public let info: YandexWeatherInfo
    public let geoObject: YandexWeatherGeoObject
    public let fact: YandexWeatherFact
    public let forecasts: [YandexWeatherForecast]
}

public struct YandexWeatherInfo: Decodable, Hashable {
    public let tzinfo: YandexWeatherTzInfo
}

public struct YandexWeatherTzInfo: Decodable, Hashable {
    public let name: String
    public let abbr: String
    public let dst: Bool
    public let offset: Int
}

public struct YandexWeatherGeoObject: Decodable, Hashable {
    public let locality: YandexWeatherLocality
}

public struct YandexWeatherLocality: Decodable, Hashable {
    public let id: Int
    public let name: String
}

public struct YandexWeatherFact: Decodable, Hashable {
    public let obsTime: Int
    public let uptime: Int
    public let temp: Int
    public let icon: String
    public let condition: String
}

public struct YandexWeatherForecast: Decodable, Hashable {
    public let hours: [YandexWeatherHour]
}

public struct YandexWeatherHour: Decodable, Hashable {
    public let hour: String
    public let hourTs: Int
    public let temp: Int
    public let icon: String
    public let condition: String
}


