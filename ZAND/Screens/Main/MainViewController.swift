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

        AppRouter.shared.presentWithNav(type: .selectableMap(model))
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

    // to presenter
    var selectedDays: [IndexPath: Bool] = [:]
    
    var presenter: MainPresenterOutput?

    var activityIndicatorView: ActivityIndicatorImpl = ActivityIndicatorView()

    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    var options: [OptionsModel] = []

    var saloons: [Saloon]?

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
}

extension MainViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MainSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch MainSection.init(rawValue: section) {
        case .option:
            return options.count
        case .beautySaloon:
            return (saloons ?? []).count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            let optionCell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCell.self)
            optionCell.configure(model: options[indexPath.item], state: .onMain)

            let isCh = selectedDays[indexPath] ?? false
            isCh ? (optionCell.isTapped = true) : (optionCell.isTapped = false)

            return optionCell
        case .beautySaloon:
            let saloonCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonCell.self)
            saloonCell.configure(model: (saloons ?? [])[indexPath.item], indexPath: indexPath)
            saloonCell.mapHandler = mapHandler
            saloonCell.favouritesHandler = favouritesHandler

            if let isInFavourite = presenter?.notContains(by: (saloons ?? [])[indexPath.item].id) {
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
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            if indexPath.section == 0 && indexPath.item == 0 {
                AppRouter.shared.presentCompletion(type: .filter(selectedDays.filter({ $0.value == true }))) { indexDict in
                    if indexDict.isEmpty {
                        self.selectedDays.removeAll()
                        self.saloons = self.presenter?.getModel(by: .saloons) as? [Saloon]
                        self.contentView.collectionView.reloadData()
                    } else {
                        let filterID = self.options[indexDict.keys.first?.item ?? 0].id ?? 0
                        self.selectedDays = indexDict
                        self.presenter?.sortModel(filterID: filterID)
                        self.contentView.collectionView.reloadData()
                        self.contentView.collectionView.scrollToItem(at: indexDict.keys.first!, at: .centeredHorizontally, animated: true)
                    }
                }
            } else {
                presenter?.sortModel(filterID: options[indexPath.item].id ?? 0)
                let cell = collectionView.cellForItem(at: indexPath) as! OptionCell

                if cell.isTapped == false {
                    cell.isTapped = true
                    selectedDays[indexPath] = true
                    let unnecessaryIndexes = selectedDays.filter({ $0.key != indexPath})
                    for (index, _) in unnecessaryIndexes {
                        selectedDays[index] = false
                        if let cell = collectionView.cellForItem(at: index) as? OptionCell {
                            cell.isTapped = false
                        }
                    }
                } else {
                    cell.isTapped = false
                    selectedDays[indexPath] = false
                }
            }
        case .beautySaloon:
            AppRouter.shared.push(.saloonDetail(.api((saloons ?? [])[indexPath.item])))
        default:
            break
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    // MARK: - MainViewDelegate methods
    
    func showSearch() {
        guard let model = saloons else { return }

        AppRouter.shared.presentSearch(type: .search(model)) { [weak self] singleModel in
            guard let self else { return }

            if let index = saloons?.firstIndex(where: { $0.id == singleModel.id} ) {
                self.contentView.scrollToItem(at: [1, index])
            }
        }
    }
}

extension MainViewController: MainViewInput {

    // MARK: - MainViewInput methods

    func getOptions(model: [OptionsModel]) {
        options = model
    }

    func updateWithSortModel(model: [Saloon]) {
        saloons = model
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }

    func hideTabBar() {
        tabBarController?.tabBar.isHidden = false
    }

    func changeFavouritesAppearence(indexPath: IndexPath) {
        contentView.changeHeartAppearance(by: indexPath)
    }

    func updateUI(model: [Saloon]) {
        saloons = model
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }

    func isActivityIndicatorShouldRotate(_ isRotate: Bool) {
        isRotate ? showIndicator() : hideIndicator()
    }

    func updateUIConection(isUpdate: Bool) {
        if isUpdate {
            DispatchQueue.main.async {
                self.contentView.collectionView.isHidden = false
                self.presenter?.updateUI()
                self.contentView.setLostConnectionAimation(isConnected: true)
            }
        } else {
            DispatchQueue.main.async {
                self.contentView.collectionView.isHidden = true
                self.contentView.setLostConnectionAimation(isConnected: false)
            }
        }
    }
}

extension MainViewController: HideNavigationBar, ActivityIndicator {}
