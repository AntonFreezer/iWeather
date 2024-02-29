//
//  ProfileViewController.swift
//  iWeather
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        
        let helloWorldLabel: UILabel = {
            let label = UILabel()
            label.font = .poppinsSemiBold(ofSize: 36)
            label.text = String(localized: "Hello World!")
            return label
        }()
        
        view.addSubview(helloWorldLabel)
        
        helloWorldLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
