//
//  YandexNetworkWeatherRequest.swift
//  YandexWeatherNetwork
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import Foundation

public enum YandexWeatherHTTPMethod: String {
    case GET
}

public protocol YandexWeatherRequest {
    associatedtype Response: Decodable
    
    var url: String { get }
    var method: YandexWeatherHTTPMethod { get }
    var parameters: [String: Any] { get } // 'Any' to allow nil or [String]
}
