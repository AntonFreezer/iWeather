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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let currentTempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        
        return label
    }()
    
    private let swipeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .white
        label.textAlignment = .left
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
                    nameLabel, descriptionLabel,
                    currentTempLabel, conditionLabel,
                    swipeLabel, swipeImageView)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // nameLabel
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
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
    public func configure(with viewModel: CityCellViewModel) {
        // nameLabel
        nameLabel.text = viewModel.name
        // descriptionlabel
        descriptionLabel.text =
        "\(viewModel.currentDate) \(viewModel.temperatureInterval)"
        // currentTempLabel
        currentTempLabel.text = viewModel.currentTemperature
        // conditionLabel
        conditionLabel.text = viewModel.condition
    }
}



