//
//  CurrentCityHeaderView.swift
//  iWeather
//
//  Created by Anton Kholodkov on 28.02.2024.
//

import UIKit

final class CurrentCityHeaderView: UIView {
    
    //MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = .night
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        
        return imageView
    }()
    
    private let profileButtonView = CustomButtonView()
    private let settingsButtonView = CustomButtonView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsSemiBold(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsRegular(ofSize: 12.91)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let currentTempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsSemiBold(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsRegular(ofSize: 21.33)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        
        return label
    }()
    
    private let swipeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .robotoRegular(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.text = String(localized: "Swipe down for details")
        
        return label
    }()
    
    private let swipeImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        
        return UIImageView(image: image)
    }()
    
    //MARK: - Lifecycle & Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubviews(imageView,
                    profileButtonView, settingsButtonView,
                    nameLabel, descriptionLabel,
                    currentTempLabel, conditionLabel,
                    swipeLabel, swipeImageView)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // profileButtonView
        profileButtonView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(25)
            make.size.equalTo(34)
        }
        // settingsButtonView
        settingsButtonView.snp.makeConstraints { make in
            make.centerY.equalTo(profileButtonView)
            make.trailing.equalToSuperview().offset(-27)
            make.height.equalTo(18)
            make.width.equalTo(34)
        }
        // nameLabel
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().multipliedBy(0.5)
        }
        // descriptionlabel
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(nameLabel)
        }
        // currentTempLabel
        currentTempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
            make.leading.equalTo(nameLabel.snp.trailing)
        }
        // conditionLabel
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTempLabel.snp.bottom)
            make.trailing.equalTo(currentTempLabel)
            make.leading.equalTo(descriptionLabel.snp.trailing)
        }
        // swipeLabel
        swipeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(swipeImageView.snp.top)
        }
        // swipeImageView
        swipeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - ViewModel
    public func configure(
        with viewModel: CityCellViewModel,
        profileHandler: (() -> Void)? = nil,
        settingsHandler: (() -> Void)? = nil) {
            
        // profileButtonView
        profileButtonView.update(with: .init(
            buttonTitle: "",
            image: .profile,
            buttonHandler: profileHandler))
        // settingsButtonView
        settingsButtonView.update(with: .init(
            buttonTitle: "",
            image: .settings,
            buttonHandler: settingsHandler))
        // nameLabel
        nameLabel.text = viewModel.name
        // descriptionlabel
        descriptionLabel.text = viewModel.currentDate + viewModel.temperatureInterval
        // currentTempLabel
        currentTempLabel.text = viewModel.currentTemperature
        // conditionLabel
        conditionLabel.text = viewModel.condition
    }
}



