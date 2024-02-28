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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
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
        contentView.addSubviews(imageView, titleLabel)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // nameLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.trailing.equalToSuperview().inset(2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = nil
    }
    
    //MARK: - ViewModel
    
    public func configure(with viewModel: CityCellViewModel) {
        // nameLabel
        titleLabel.text = "\(viewModel.name) \(viewModel.currentTemperature)"
        
        // imageView
        imageView.image = viewModel.image
        
    }
}


