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

        if !UserDBManager.shared.isUserContains() {
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
    }

    deinit {
        print("MainViewController died")
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
            presenter?.selectedDays[indexPath] = true
            let unnecessaryIndexes = presenter?.selectedDays.filter({ $0.key != indexPath}) ?? [:]
            for (index, _) in unnecessaryIndexes {
                presenter?.selectedDays[index] = false
                if let cell = collectionView.cellForItem(at: index) as? OptionCell {
                    cell.isTapped = false
                }
            }
        } else {
            cell.isTapped = false
            presenter?.selectedDays[indexPath] = false
        }
    }

    private func showFilterVC() {
        AppRouter.shared.presentCompletion(
            type: .filter((presenter?.selectedDays ?? [:]).filter({ $0.value == true }))
        ) { [weak self] indexDict in
            guard let self else { return }

            if indexDict.isEmpty {
                self.presenter?.selectedDays.removeAll()
                self.presenter?.backToInitialState()
                self.reloadDataAnimation()
            } else {
                let filterID = self.presenter?.optionsModel[indexDict.keys.first?.item ?? 0].id ?? 0
                self.presenter?.selectedDays = indexDict

                self.presenter?.sortModel(filterID: filterID)
                self.reloadData()
                self.contentView.collectionView.scrollToItem(
                    at: indexDict.keys.first!,
                    at: .centeredHorizontally,
                    animated: true
                )
            }
        }
    }

    private func reloadDataAnimation() {
        let range = Range(uncheckedBounds: (0, 2))
        let indexSet = IndexSet(integersIn: range)

        self.contentView.collectionView.performBatchUpdates {
            self.contentView.collectionView.reloadSections(indexSet)
        }
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
            return presenter?.optionsModel.count ?? 0
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
            optionCell.configure(model: (presenter?.optionsModel[indexPath.item])!, state: .onMain)

            let isCh = presenter?.selectedDays[indexPath] ?? false
            isCh ? (optionCell.isTapped = true) : (optionCell.isTapped = false)

            return optionCell
        case .beautySaloon:
            let saloonCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonCell.self)
            saloonCell.configure(model: (presenter?.sortedSaloons ?? [])[indexPath.item], indexPath: indexPath)
            saloonCell.mapHandler = mapHandler
            saloonCell.favouritesHandler = favouritesHandler

            if let isInFavourite = presenter?.contains(by: (presenter?.sortedSaloons ?? [])[indexPath.item].id) {
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

                let isSelectedFiltersEmpty = (presenter?.selectedDays ?? [:]).filter{ $0.value == true }.isEmpty
                if isSelectedFiltersEmpty {
                    presenter?.backToInitialState()
                    collectionView.reloadSections(IndexSet(integer: 1))
                    collectionView.scrollToItem(at: [0,0], at: .left, animated: true)
                } else {
                    self.presenter?.sortModel(filterID: presenter?.optionsModel[indexPath.item].id ?? 0)
                    self.reloadData()
                    self.contentView.collectionView.scrollToItem(
                        at: indexPath, at: .centeredHorizontally, animated: true
                    )
                }
            }
        case .beautySaloon:
            AppRouter.shared.push(.saloonDetail(.api((presenter?.sortedSaloons ?? [])[indexPath.item]), ""))
        default:
            break
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    // MARK: - MainViewDelegate methods
    
    func showSearch() {
        guard let model = presenter?.sortedSaloons else { return }

        AppRouter.shared.presentSearch(type: .search(model, [])) { [weak self] singleModel in
            guard let self else { return }

            if let index = model.firstIndex(where: { $0.id == singleModel.id} ) {
                self.contentView.scrollToItem(at: [1, index])
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
