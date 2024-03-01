//
//  YandexWeatherNetworkError.swift
//  YandexWeatherNetwork
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import Foundation

public enum YandexWeatherNetworkError: Error {
    case invalidURL
    case invalidApiKey
    case invalidDecoding
    case invalidErrorDecoding
    case failedRequest
    case resourceNotFound
    case networkError(YandexWeatherErrorEntity?, URLError?)
}

public struct YandexWeatherErrorEntity: Decodable {
    let code: Int
    let msg: String
}
