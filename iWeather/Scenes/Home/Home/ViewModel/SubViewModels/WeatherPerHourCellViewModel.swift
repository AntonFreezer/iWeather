//
//  WeatherPerHourCellViewModel.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit
import SVGKit

struct WeatherPerHourCellViewModel: Hashable {
    
    //MARK: - Properties
    private let hour: WeatherPerHour
    
    public var imageURL: URL? {
        URL(string: hour.iconURL)
    }
    
    public var currentTemperature: String {
        "\(hour.currentTemp)°C"
    }
    
    public var hourFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: hour.hour) {
            formatter.dateFormat = "h:mma"
            var formattedTime = formatter.string(from: date)
            if formattedTime == "12:00AM" {
                formattedTime = "0:00AM"
            }
            return formattedTime
        } else {
            return "0:00AM"
        }
    }
    
    //MARK: - Lifecycle && Setup
    init(hour: WeatherPerHour) {
        self.hour = hour
    }
    
}

