//
//  CustomButtonView.swift
//  iWeather
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import UIKit

final class CustomButtonView: CustomView {
    private let button = UIButton(type: .system)
    private var didTapButtonHandler: (() -> Void)?
    
    override func configure() {
        addSubviews(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.tintColor = .white
        button.titleLabel?.font = .poppinsMedium(ofSize: 14)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapButton() {
        didTapButtonHandler?()
    }
}

extension CustomButtonView: Configurable {
    struct Model {
        let buttonTitle: String
        let image: UIImage?
        let buttonHandler: (() -> Void)?
    }
    
    func update(with model: Model?) {
        guard let model else {
            return
        }
        
        button.setTitle(model.buttonTitle, for: .normal)
        didTapButtonHandler = model.buttonHandler
        button.isHidden = model.buttonHandler == nil
        button.setBackgroundImage(model.image, for: .normal)
    }
}
