//
//  SettingsViewController.swift
//  iWeather
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        
        view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
}
