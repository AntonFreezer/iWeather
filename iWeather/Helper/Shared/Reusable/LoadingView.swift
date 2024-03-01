//
//  LoadingView.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import UIKit
import SnapKit

final class LoadingView: CustomView {
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func configure() {
        spinner.color = .white
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        
        spinner.snp.makeConstraints {
            $0.size.equalTo(90)
            $0.center.equalToSuperview()
        }
    }
}
