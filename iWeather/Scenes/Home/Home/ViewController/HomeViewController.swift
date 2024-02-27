//
//  HomeViewController.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit
import Combine

typealias TextHeader = SectionHeaderCollectionReusableView<CustomLabelView>

final class HomeViewController: GenericViewController<HomeView> {
    
    //MARK: - Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeViewModel.Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Section, Item>
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    //MARK: - IO
    private let viewModel: HomeViewModel
    
    private var output: AnyPublisher<HomeViewModel.Input, Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<HomeViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Lifecycle & Setup
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        
        configureDataSource()
        setupView()
        bindViewModel()
        
        subject.send(.viewDidLoad)
    }
    
    private func setupView() {
        self.showLoading()
        rootView.viewModel = self.viewModel
        rootView.collectionView?.delegate = self
        rootView.backgroundColor = .black
    }
    
    private func bindViewModel() {
        viewModel.transform(input: output)
            .receive(on: RunLoop.main)
            .sink { [unowned self] event in
                self.hideLoading()
                
                switch event {
                case .didLoadCities:
                    self.applyShapshot()
                case .didReceiveError(let error):
                    self.showError(error)
                }
            }.store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        self.showError(
            String(localized: "Couldn't load cities"),
            message: error.localizedDescription,
            actionTitle: String(localized: "Refresh"),
            action: { stub in
                stub.removeFromSuperview()
                self.showLoading()
                self.subject.send(.viewDidLoad)
            }
        )
    }
    
}

//MARK: - UICollectionViewDiffableDataSource && Snapshot
private extension HomeViewController {
    func configureDataSource() {
        dataSource = DataSource(
            collectionView: rootView.collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
        
            switch item {
            case .city(let city):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CityCollectionViewCell.cellIdentifier,
                    for: indexPath) as! CityCollectionViewCell
                cell.configure(with: CityCellViewModel(city: city))
                return cell
                
            case .weatherPerHour(let weatherPerHour):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WeatherPerHourCollectionViewCell.cellIdentifier,
                    for: indexPath) as! WeatherPerHourCollectionViewCell
                cell.configure(with: WeatherPerHourCellViewModel(hour: weatherPerHour))
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { 
            collectionView, kind, indexPath in
            
            switch self.snapshot.sectionIdentifiers[indexPath.section] {
            case .citiesList:
                return UICollectionReusableView(frame: .zero)
            case .weatherPerHourList:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TextHeader.identifier, for: indexPath) as! TextHeader
                header.update(with: .init(
                    text: .init(
                        text: String(localized: "Today"),
                        font: .boldSystemFont(ofSize: 16),
                        textColor: .white,
                        numberOfLines: 1)))
                return header
            }
        }
    }
    
    func applyShapshot(animatingDifferences: Bool = true) {
        snapshot = Snapshot()
        
        snapshot.appendSections([.citiesList])
        snapshot.appendItems(viewModel.cities.map { .city($0) },
                             toSection: .citiesList)
        
        if let currentCity = viewModel.currentCity {
            snapshot.appendItems(currentCity.hours.map { .weatherPerHour($0) },
                                 toSection: .weatherPerHourList)
            snapshot.appendSections([.weatherPerHourList])
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let city = dataSource.itemIdentifier(for: indexPath) else { return }
        
        subject.send(.didSelectCity(city: city))
    }
    
}

//MARK: - Item
extension HomeViewController {
    enum Item: Hashable {
        case city(City)
        case weatherPerHour(WeatherPerHour)
    }
}
