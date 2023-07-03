//
//  File.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {

    // MARK: - Closures

    private lazy var mapHandler = { [weak self] (id: Int) in
        guard let self,
              let model = self.presenter?.getModel(by: id) else { return }

        AppRouter.shared.push(.selectableMap(model))
    }

    private lazy var favouritesHandler: (Int, IndexPath) -> () = { [weak self] id, indexPath in
        guard let self else { return }

        self.presenter?.applyDB(by: id) { [weak self] in
            self?.contentView.changeHeartAppearence(by: indexPath)
        }
    }
    
    // MARK: - Properties
    
    var presenter: MainPresenterOutput?

    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    var options: [OptionsModel] {
        presenter?.getModel(by: .options) as! [OptionsModel]
    }

    var saloons: [SaloonMockModel] {
        presenter?.getModel(by: .saloons) as! [SaloonMockModel]
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        subscribeNotify()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
        checkIsUserLaunched()
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
    
    private func checkIsUserLaunched() {
        if OnboardManager.shared.isUserFirstLaunch() {
            addChild()
        }
    }
    
    private func addChild() {
        let factory: DefaultVCFactory = VCFactory()
        let viewController = factory.getViewController(for: .register)
        addChildren(viewController: viewController)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func subscribeNotify() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getNotifyAction(_:)),
            name: .showTabBar,
            object: nil
        )
    }
    
    // MARK: - Action
    
    @objc
    private func getNotifyAction(_ notification: Notification) {
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
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
            return saloons.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionCell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCell.self)
        let saloonCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonCell.self)

        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            optionCell.configure(model: options[indexPath.item], state: .onMain)
            return optionCell
        case .beautySaloon:
            saloonCell.configure(model: saloons[indexPath.item], indexPath: indexPath)
            saloonCell.mapHandler = mapHandler
            saloonCell.favouritesHandler = favouritesHandler

            if let isInFavourite = presenter?.contains(by: saloons[indexPath.item].id) {
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
        case .beautySaloon:
            AppRouter.shared.push(.saloonDetail(saloons[indexPath.item]))
        default:
            break
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    // MARK: - MainViewDelegate methods
    
    func showSelectableMap(model: CommonModel) {
        AppRouter.shared.push(.selectableMap(model))
    }
    
    func showSearch() {
        guard let model = presenter?.getModel(by: .saloons) as? [SaloonMockModel] else {
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

    // MARK: - MainViewProtocol methods

}

extension MainViewController: HideNavigationBar {}
