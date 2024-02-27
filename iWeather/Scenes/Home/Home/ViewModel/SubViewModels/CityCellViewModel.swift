//
//  CityCellViewModel.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

struct CityCellViewModel: Hashable {
    
    //MARK: - Properties
    private let city: City
    
    public var image: UIImage {
        switch city.condition {
        case .clear:
            return UIImage(named: "clear")!
        default:
            return UIImage(named: "overcastWeather")!
        }
    }
    
    public var name: String {
        city.name
    }
    
    public var condition: String {
        city.condition.localized()
    }
    
    public var currentTemperature: String {
        "\(city.currentTemp)°C"
    }
    
    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM EEE"
        dateFormatter.timeZone = TimeZone(identifier: city.timezoneIdentifier)
        return dateFormatter
    }
    
    public var currentDate: String {
        guard let date = isoFormatter.date(from: city.date) else { return city.date }
        return dateFormatter.string(from: date)
    }
    
    public var temperatureInterval: String {
        let min: String = city.hours.map { $0.hour }.min() ?? "0"
        let max: String = city.hours.map { $0.hour }.max() ?? "0"
        
        return "\(min)°C/\(max)"
    }
    
    //MARK: - Lifecycle && Setup
    init(city: City) {
        self.city = city
    }
}
