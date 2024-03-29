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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        rootView.viewModel = self.viewModel
        rootView.collectionView?.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.transform(input: output)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                self.hideLoading()
                
                switch event {
                case .didLoadCities:
                    self.applyShapshot()
                    self.scrollToCurrentHour()
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
            cellProvider: { collectionView, indexPath, item in
                
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
                        font: .poppinsMedium(ofSize: 20),
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
            reloadHeaderView(with: currentCity)
            
            snapshot.appendSections([.weatherPerHourList])
            snapshot.appendItems(
                currentCity.hours.map { .weatherPerHour($0) },
                toSection: .weatherPerHourList)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func reloadHeaderView(with city: City) {
        rootView.headerView.configure(
            with: CityCellViewModel(city: city),
            profileHandler: { 
                self.subject.send(.didTapProfile)
            },
            settingsHandler: {
                self.subject.send(.didTapSettings)
            })
    }
}

//MARK: - CollectionView Delegate && Custom
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .city(let city):
            subject.send(.didSelectCity(city: city))
        default:
            return
        }
    }
    
    private func scrollToCurrentHour() {
        if let currentCity = viewModel.currentCity,
           let sectionIndex = snapshot.indexOfSection(.weatherPerHourList) {
            
            let timezone = TimeZone(identifier: currentCity.timezoneIdentifier) ?? .autoupdatingCurrent
            let currentHour = Calendar.current
                .dateComponents(in: timezone, from: Date()).hour ?? 0
            
            let hourIndexToScroll = currentHour - 1
            
            guard 0..<24 ~= hourIndexToScroll else { return }
            
            let indexPath = IndexPath(item: hourIndexToScroll, section: sectionIndex)
            rootView.collectionView.scrollToItem(
                at: indexPath,
                at: .left,
                animated: true)
        }
    }
    
}

//MARK: - Diffable DataSource Item
extension HomeViewController {
    enum Item: Hashable {
        case city(City)
        case weatherPerHour(WeatherPerHour)
    }
}
