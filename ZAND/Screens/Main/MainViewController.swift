//
//  MainViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit
import Moya

final class MainViewController: BaseViewController<MainView> {

    // MARK: - Closures

    private lazy var mapHandler = { [weak self] (id: Int) in
        guard let self,
              let model = self.presenter?.getModel(by: id) else { return }

        AppRouter.shared.presentRecordNavigation(type: .selectableMap(model))
    }

    private lazy var favouritesHandler: (Int, IndexPath) -> () = { [weak self] id, indexPath in
        guard let self else { return }

        if TokenManager.shared.bearerToken == nil {
            AppRouter.shared.changeTabBarVC(to: 2)
        } else {
            self.presenter?.applyDB(by: id) { [weak self] in
                self?.contentView.changeHeartAppearance(by: indexPath)
            }
        }
    }
    
    // MARK: - Properties

    var presenter: MainPresenterOutput?

    var activityIndicatorView: ActivityIndicatorImpl = ActivityIndicatorView()

    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
        showBadConnectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if presenter?.isShowAttention == true {
            showAlertLocation()
        }
    }

    // MARK: - Instance methods
    
    private func subscribeDelegate() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.delegate = self
    }

    private func selectCellHelper(
        cell: UICollectionViewCell?,
        indexPath: IndexPath,
        collectionView: UICollectionView
    ) {
        let cell = collectionView.cellForItem(at: indexPath) as! OptionCell

        if cell.isTapped == false {
            cell.isTapped = true
            presenter?.selectedFilters[indexPath] = true
            let unnecessaryIndexes = presenter?.selectedFilters.filter({ $0.key != indexPath}) ?? [:]
            for (index, _) in unnecessaryIndexes {
                presenter?.selectedFilters[index] = false
                if let cell = collectionView.cellForItem(at: index) as? OptionCell {
                    cell.isTapped = false
                }
            }
        } else {
            cell.isTapped = false
            presenter?.selectedFilters[indexPath] = false
        }
    }

    private func showFilterVC() {
        AppRouter.shared.presentFilterVC(
            type: .filter(
                (presenter?.updateDict() ?? [:]).filter({ $0.value == true }),
                nearestIsActive: presenter?.state == .all ? false : true)
        ) { [weak self] indexDict, nearestIsActive in
            guard let self else { return }

            self.presenter?.state = nearestIsActive ? .near : .all

            if indexDict.isEmpty && nearestIsActive == false {
                self.setupDefaultState()
            } else if indexDict.isEmpty {
                self.presenter?.selectedFilters.removeAll()
            } else {
                let filterID = OptionsModel.options[indexDict.keys.first?.item ?? 0].id ?? 0
                self.presenter?.selectedFilters = indexDict
                self.presenter?.sortModel(filterID: filterID)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.contentView.collectionView.scrollToItem(
                        at: indexDict.keys.first!,
                        at: .centeredHorizontally,
                        animated: true
                    )
                }
            }
        }
    }

    private func showBadConnectionView() {
        if presenter?.isFirstLaunch == true {
            contentView.showBadConnectionView()
            presenter?.isFirstLaunch = false
        }
    }

    private func setupDefaultState() {
        self.presenter?.selectedFilters.removeAll()
        self.presenter?.state = .all
    }

    private func showAlertLocation() {
        let alertController = UIAlertController(
            title: AssetString.geoIsOff.rawValue,
            message: nil,
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(
            title: AssetString.yes.rawValue,
            style: .default
        ) { alert in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: AssetString.no.rawValue, style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        presenter?.isShowAttention = false
    }
}

extension MainViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MainSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch MainSection.init(rawValue: section) {
        case .option:
            return OptionsModel.options.count
        case .beautySaloon:
            return presenter?.sortedSaloons.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            let optionCell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCell.self)
            optionCell.configure(model: OptionsModel.options[indexPath.item], state: .onMain)

            let isCh = presenter?.selectedFilters[indexPath] ?? false
            isCh ? (optionCell.isTapped = true) : (optionCell.isTapped = false)

            return optionCell
        case .beautySaloon:
            let saloonCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonCell.self)
            saloonCell.configure(model: (presenter?.sortedSaloons ?? [])[indexPath.item], indexPath: indexPath)
            saloonCell.mapHandler = mapHandler
            saloonCell.favouritesHandler = favouritesHandler

            if let saloons = presenter?.sortedSaloons as? [SaloonModel],
               let isInFavourite = presenter?.contains(by: saloons[indexPath.item].saloonCodable.id) {
                saloonCell.isInFavourite = !isInFavourite
            }

            return saloonCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            if indexPath.section == 0 && indexPath.item == 0 {
                showFilterVC()
            } else {
                let cell = collectionView.cellForItem(at: indexPath)
                selectCellHelper(cell: cell, indexPath: indexPath, collectionView: collectionView)

                let isSelectedFiltersEmpty = (presenter?.selectedFilters ?? [:]).filter{ $0.value == true }.isEmpty
                if isSelectedFiltersEmpty {
                    presenter?.state = presenter?.state == .all ? .all : .near
                    collectionView.scrollToItem(at: [0,0], at: .left, animated: true)
                } else {
                    self.presenter?.sortModel(filterID: OptionsModel.options[indexPath.item].id ?? 0)
                    self.contentView.collectionView.scrollToItem(
                        at: indexPath,
                        at: .centeredHorizontally,
                        animated: true
                    )
                }
            }
        case .beautySaloon:
            AppRouter.shared.push(.saloonDetail((presenter?.sortedSaloons ?? [])[indexPath.item]))
        default:
            break
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    // MARK: - MainViewDelegate methods
    
    func showSearch() {
        guard let allSalons = presenter?.allSalons else { return }

        AppRouter.shared.presentSearch(
            type: .search(
                presenter?.sortedSalonsByUserLocation() ?? [],
                allModel: allSalons,
                state: presenter?.state
            )) { [weak self] state, model in
                guard let self else { return }

                switch state {
                case let .saloonZoom(stateIndex, _, _):
                    self.presenter?.state = stateIndex == 0 ? .near : .all
                    self.presenter?.selectedFilters.removeAll()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let index = self.presenter?.sortedSaloons.firstIndex(
                            where: { $0.saloonCodable.id == model?.saloonCodable.id }
                        ) {
                            self.contentView.scrollToItem(at: [1, index])
                        }
                    }

                case .near:
                    if self.presenter?.state != .near {
                        self.presenter?.state = state
                        self.presenter?.selectedFilters.removeAll()
                        self.contentView.collectionView.scrollToItem(at: [0,0], at: .top, animated: true)
                    }
                case .all:
                    if self.presenter?.state != .all {
                        self.presenter?.state = state
                        self.presenter?.selectedFilters.removeAll()
                        self.contentView.collectionView.scrollToItem(at: [0,0], at: .top, animated: true)
                    }
                default:
                    break
                }
            }
    }
}

extension MainViewController: MainViewInput {

    // MARK: - MainViewInput methods

    func hideTabBar() {
        tabBarController?.tabBar.isHidden = false
    }

    func changeFavouritesAppearence(indexPath: IndexPath) {
        contentView.changeHeartAppearance(by: indexPath)
    }

    func isActivityIndicatorShouldRotate(_ isRotate: Bool) {
        isRotate ? showIndicator() : hideIndicator()
    }

    func updateUIConection(isConnected: Bool) {
        if isConnected {
            DispatchQueue.main.async {
                self.contentView.collectionView.isHidden = false
                self.presenter?.fetchData()
                self.contentView.setLostConnectionAimation(isConnected: true)
            }
        } else {
            DispatchQueue.main.async {
                self.contentView.collectionView.isHidden = true
                self.contentView.setLostConnectionAimation(isConnected: false)
            }
        }
    }

    func reloadData() {
        contentView.reloadData()
    }

    func showEmptyLabel(isShow: Bool) {
        contentView.isLabelShows(isShow)
    }
}

extension MainViewController: HideNavigationBar, ActivityIndicator {}
