//
//  CustomView.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import UIKit

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() { }
}

