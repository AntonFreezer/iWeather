//
//  HomeViewModel.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit
import Combine

final class HomeViewModel: NSObject, IOViewModelType {
    
    //MARK: - Properties
    typealias Router = Routable
    private(set) var router: any Router
    
    enum Section: Hashable, CaseIterable {
        case citiesList
        case weatherPerHourList
    }
    
    public var cities: [City] = []
    public var currentCity: City?
    
    private let subject = PassthroughSubject<Output, Never>()
    var output: AnyPublisher<Output, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Setup && Lifecycle
    init(router: any Router) {
        self.router = router
    }
    
    //MARK: - IO
    enum Input {
        case viewDidLoad
        case didSelectCity(city: City)
    }
    
    enum Output {
        case didLoadCities
        case didReceiveError(Error)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                fetchWeather()
                currentCity = self.cities.first!
            case .didSelectCity(let city):
                return
            }
        }.store(in: &cancellables)
        
        return output
    }
    
}

//MARK: - Network
private extension HomeViewModel {
    func fetchWeather() {
        
        self.cities = City.mockCities
        subject.send(.didLoadCities)
    }
}

//MARK: - CollectionView Rendering
extension HomeViewModel: HomeViewCollectionViewRendering {
    
    private var defaultInterItemSpacing: CGFloat { 20 }
    private var defaultInterGroupSpacing: CGFloat { defaultInterItemSpacing }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        return header
    }
    
    func createCitiesSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(215)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(defaultInterItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = defaultInterGroupSpacing
        section.contentInsets.bottom = 27
        
        return section
    }
    
    func createWeatherPerHourSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(90)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(defaultInterItemSpacing)
        
        let header = createSectionHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = defaultInterGroupSpacing
        section.contentInsets.top = 6
    
        return section
        
    }
    
}

//MARK: - Sections
extension HomeViewModel {
    
}
