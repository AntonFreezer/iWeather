//
//  WeatherPerHourCollectionViewCell.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit
import Kingfisher

final class WeatherPerHourCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static var cellIdentifier: String {
        return String(describing: WeatherPerHourCollectionViewCell.self)
    }
    
    //MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .hourBackground
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsMedium(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsSemiBold(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: - Lifecycle & Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubviews(containerView, hourLabel)
        containerView.addSubviews(imageView, tempLabel)
    }
    
    private func setupLayout() {
        // containerView
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tempLabel)
        }
        
        // imageView
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        
        // tempLabel
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        // hourLabel
        hourLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(3)
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.tempLabel.text = nil
        self.hourLabel.text = nil
    }
    
    //MARK: - Public
    public func configure(with viewModel: WeatherPerHourCellViewModel) {
        // nameLabel
        tempLabel.text = viewModel.currentTemperature
        
        // hourLabel
        hourLabel.text = viewModel.hourFormatted

        // imageView
        imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [.cacheMemoryOnly,
                      .transition(.fade(0.15)),
                      .processor(SVGImgProcessor())
                     ])
        
    }
    
    public func setHourLabelAsCurrent() {
        self.hourLabel.text = "Now"
    }
}
