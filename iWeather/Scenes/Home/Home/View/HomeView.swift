//
//  HomeView.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

protocol HomeViewCollectionViewRendering: BasicViewModelType {
    func createCitiesSectionLayout() -> NSCollectionLayoutSection
    func createWeatherPerHourSectionLayout() -> NSCollectionLayoutSection
}

final class HomeView: UIView {
    
    //MARK: - Properties
    var viewModel: (any HomeViewCollectionViewRendering)?
    
    //MARK: - UI Components
    let headerView = CurrentCityHeaderView()
    private(set) var collectionView: UICollectionView!
    
    //MARK: - Lifecycle & Setup
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setupView() {
        backgroundColor = .homeBackground
        
        self.collectionView = createCollectionView()
        addSubviews(headerView, collectionView!)
    }
    
    private func setupLayout() {
        // headerView
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-30)
        }
        // collectionView
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Collection View
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(
            CityCollectionViewCell.self,
            forCellWithReuseIdentifier: CityCollectionViewCell.cellIdentifier)
        collectionView.register(
            WeatherPerHourCollectionViewCell.self,
            forCellWithReuseIdentifier: WeatherPerHourCollectionViewCell.cellIdentifier)
        collectionView.register(
            TextHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TextHeader.identifier)
                
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection? {
        let sectionTypes = HomeViewModel.Section.allCases
        
        switch sectionTypes[sectionIndex] {
        case .citiesList:
            return viewModel?.createCitiesSectionLayout()
        case .weatherPerHourList:
            return viewModel?.createWeatherPerHourSectionLayout()
        }
    }
}
