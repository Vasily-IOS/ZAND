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
    
    var presenter: MainPresenterOutput?

    var activityIndicatorView: ActivityIndicatorImpl = ActivityIndicatorView()

    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    var options: [OptionsModel] {
        presenter?.getModel(by: .options) as! [OptionsModel]
    }

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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            if indexPath.section == 0 && indexPath.item == 0 {
                AppRouter.shared.present(type: .filter)
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        guard let model = presenter?.getModel(by: .saloons) as? [Saloon] else {
            return
        }

        AppRouter.shared.presentSearch(type: .search(model)) { [weak self] singleModel in
            guard let self else { return }

            if let index = self.presenter?.getSearchIndex(id: singleModel.id) {
                self.contentView.scrollToItem(at: index)
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
        contentView.collectionView.reloadItems(at: [indexPath])
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
