//
//  YandexWeatherNetworkTests.swift
//  YandexWeatherNetworkTests
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import XCTest
@testable import YandexWeatherNetwork

final class YandexWeatherNetworkTests: XCTestCase {
    
    var sut: YandexWeatherNetworkClient!
    
    /// either add env.xcconfig manually and define your the API_KEY
    /// or refactor the network client and hardcode your apikey
    func testApiKey() {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"]!
        print(apiKey)
        XCTAssertFalse(apiKey.isEmpty)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultYandexWeatherNetworkClient(
            baseURL: "https://api.weather.yandex.ru/v2",
            apiKey: ProcessInfo.processInfo.environment["API_KEY"]!
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testDefaultWeatherRequest() {
        let expectation = expectation(description: "Yandex Weather weather data default request")
        
        Task {
            let result = await sut.sendRequest(
                request: YandexWeatherNetworkForecastsRequest(
                    latitude: 55.7558,
                    longitude: 37.6173))
            expectation.fulfill()
            
            guard let value = try? result.get() else {
                XCTFail("Failed to fetch or cast weather data")
                return
            }
            
            XCTAssertTrue(value.forecasts.allSatisfy { $0.hours.count == 24 })
            
        }
        
        wait(for: [expectation])
    }
    
}
