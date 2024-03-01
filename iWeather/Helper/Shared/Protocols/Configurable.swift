//
//  Configurable.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import UIKit

protocol Configurable: UIView {
    associatedtype Model
    
    func update(with model: Model?)
}
