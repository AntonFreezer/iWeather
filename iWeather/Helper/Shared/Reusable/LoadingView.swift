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
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        
        spinner.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }
}
