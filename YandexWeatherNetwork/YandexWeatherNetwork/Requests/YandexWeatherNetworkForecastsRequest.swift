//
//  YandexWeatherNetworkForecastsRequest.swift
//  YandexWeatherNetwork
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import Foundation

public struct YandexWeatherNetworkForecastsRequest: YandexWeatherRequest {
    public typealias Response = YandexWeatherNetworkForecastsEntity
    
    public var url: String {
        "/forecast"
    }
    
    public init(latitude: Double,
                longitude: Double,
                language: String = "en_US",
                limit: Int = 1) {
        parameters["lat"] = "\(latitude)"
        parameters["lon"] = "\(longitude)"
        parameters["language"] = language
        parameters["limit"] = "\(limit)"
    }
    
    public var method: YandexWeatherHTTPMethod {
        .GET
    }
    
    public var parameters: [String: Any] = [
        "hours": "true",
        "extra": "false"
    ]
}
