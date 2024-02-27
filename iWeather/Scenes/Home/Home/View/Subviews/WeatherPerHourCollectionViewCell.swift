//
//  WeatherPerHourCollectionViewCell.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

final class WeatherPerHourCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static var cellIdentifier: String {
        return String(describing: WeatherPerHourCollectionViewCell.self)
    }
    
    //MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .purple
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .bold)
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
        containerView.addSubviews(imageView, tempLabel)
        
        contentView.backgroundColor = .clear
        contentView.addSubviews(containerView, hourLabel)
    }
    
    private func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // nameLabel
        tempLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(imageView).inset(16)
        }
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        // hourLabel
        hourLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.tempLabel.text = nil
        self.hourLabel.text = nil
    }
    
    //MARK: - PictureCollectionViewCell ViewModel
    
    public func configure(with viewModel: WeatherPerHourCellViewModel) {
        // nameLabel
        tempLabel.text = viewModel.hourFormatted
        
        // imageView
        imageView.setImage(
            with: viewModel.imageURL,
            cornerRadius: 0,
            resize: false,
            crop: false,
            resizeMode: .none,
            processorOptions: [SVGImgProcessor(identifier: "com.iWeather.\(Self.cellIdentifier)SVGProcessor")])
        
    }
}
