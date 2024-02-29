//
//  BasicViewModelType.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import Foundation

protocol BasicViewModelType {
    associatedtype Router
    var router: Router { get }
}
