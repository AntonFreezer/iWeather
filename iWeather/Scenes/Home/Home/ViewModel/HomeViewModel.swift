//
//  HomeViewModel.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit
import Combine
import YandexWeatherNetwork

final class HomeViewModel: NSObject, IOViewModelType {
    
    //MARK: - Properties
    typealias Router = Routable
    private(set) var router: any Router
    
    private let networkService: YandexWeatherNetworkClient
    
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
    init(router: any Router, networkService: YandexWeatherNetworkClient) {
        self.router = router
        self.networkService = networkService
    }
    
    //MARK: - IO
    enum Input {
        case viewDidLoad
        case didTapProfile
        case didTapSettings
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
                Task { await fetchWeather() }
            case .didTapProfile:
                if let router = router as? (any HomeRouter) {
                    router.process(route: .profileScreen)
                }
            case .didTapSettings:
                if let router = router as? (any HomeRouter) {
                    router.process(route: .settingsScreen)
                }
            case .didSelectCity(let city):
                currentCity = cities.first(where: { $0 == city })
                subject.send(.didLoadCities)
            }
        }.store(in: &cancellables)
        
        return output
    }
    
}

//MARK: - Network
private extension HomeViewModel {
    func fetchWeather() async {
        await withTaskGroup(of: City?.self) { group in
            for location in City.citiesWithLocations.values {
                group.addTask {
                    let result = await self.networkService.sendRequest(request: YandexWeatherNetworkForecastsRequest(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude))
                    
                    switch result {
                    case .success(let data):
                        let tz = data.info.tzinfo.name
                        return City(name: data.geoObject.locality.name,
                                    date: data.nowDt,
                                    timezoneIdentifier: tz,
                                    currentTemp: "\(data.fact.temp)",
                                    condition: "\(data.fact.condition)",
                                    hours: data.forecasts.first!.hours.map { .init(
                                        hour: $0.hour,
                                        isCurrentHour: self.isCurrentHour(
                                            fromTimezone: tz, hour: $0.hour),
                                        currentTemp: "\($0.temp)",
                                        iconName: $0.icon) })
                    case .failure(let failure):
                        self.subject.send(.didReceiveError(failure))
                        return nil
                    }
                }
            }
            
            var cities = [City]()
            for await city in group {
                if let city {
                    cities.append(city)
                }
            }
            
            self.currentCity = cities.first
            self.cities = cities
            subject.send(.didLoadCities)
        }
    }
    
    func isCurrentHour(fromTimezone identifier: String, hour: String) -> Bool {
        let timezone = TimeZone(identifier: identifier) ?? .autoupdatingCurrent
        let currentHour = Calendar.current
            .dateComponents(in: timezone, from: Date()).hour ?? 0
        
        if String(currentHour) == hour {
            return true
        }
        
        return false
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
                heightDimension: .estimated(100)),
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

