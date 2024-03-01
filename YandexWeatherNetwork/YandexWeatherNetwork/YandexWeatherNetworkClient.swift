//
//  YandexWeatherNetworkClient.swift
//  YandexWeatherNetwork
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import Foundation

public protocol YandexWeatherNetworkClient: Actor {
    func sendRequest<Request>(request: Request) async -> Result<Request.Response, YandexWeatherNetworkError> where Request: YandexWeatherRequest
}

public actor DefaultYandexWeatherNetworkClient: YandexWeatherNetworkClient {
    
    private let baseURL: String
    private var apiKey: String?
    
    public init(baseURL: String, apiKey: String? = nil) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    public func sendRequest<Request>(request: Request) async -> Result<Request.Response, YandexWeatherNetworkError> where Request : YandexWeatherRequest {
        
        let fullURL = request.url.starts(with: "https") ? request.url : baseURL + request.url
        guard var urlComponents = URLComponents(string: fullURL) else {
            return .failure(.invalidURL)
        }
        
        if !request.parameters.isEmpty {
            urlComponents.queryItems = request.parameters.compactMap { item -> URLQueryItem? in
                if let value = item.value as? String { // may be 'Any' -> 'nil' from protocol definition
                    return URLQueryItem(name: item.key, value: value)
                } else {
                    return nil
                }
            }
            
            request.parameters.forEach { item in
                if let value = item.value as? [String] { // multiple values
                    urlComponents.queryItems?.append(contentsOf: value.map {
                        .init(name: item.key, value: $0)
                    })
                }
            }
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue(apiKey ?? "", forHTTPHeaderField: "X-Yandex-API-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.failedRequest)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            switch response.statusCode {
            case 200...299:
                guard let decoded = try? decoder.decode(Request.Response.self, from: data)
                else {
                    return .failure(.invalidDecoding)
                }
                return .success(decoded)
                
            case 400:
                return .failure(.failedRequest)
                
            case 401, 403:
                return .failure(.invalidApiKey)
                
            case 404:
                return .failure(.resourceNotFound)
                
            default:
                guard let decoded = try? decoder.decode(YandexWeatherErrorEntity.self, from: data)
                else {
                    return .failure(.invalidErrorDecoding)
                }
                
                return .failure(.networkError(decoded, nil))
            }
            
        } catch {
            return .failure(.networkError(nil, error as? URLError))
        }
    }
    
}

