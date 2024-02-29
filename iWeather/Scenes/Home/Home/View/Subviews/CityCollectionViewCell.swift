//
//  CityCollectionViewCell.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

final class CityCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static var cellIdentifier: String {
        return String(describing: CityCollectionViewCell.self)
    }
    
    //MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsSemiBold(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .poppinsSemiBold(ofSize: 18.8)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        
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
        contentView.backgroundColor = .clear
        contentView.addSubviews(imageView, nameLabel, tempLabel)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // nameLabel
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(5)
        }
        // tempLabel
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.nameLabel.text = nil
        self.tempLabel.text = nil
    }
    
    //MARK: - ViewModel
    
    public func configure(with viewModel: CityCellViewModel) {
        // imageView
        imageView.image = viewModel.image
        // nameLabel
        nameLabel.text = viewModel.name
        // tempLabel
        tempLabel.text = viewModel.currentTemperature
    }
}


