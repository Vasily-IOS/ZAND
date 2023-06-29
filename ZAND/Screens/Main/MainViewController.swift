//
//  File.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {
    
    // MARK: - Properties
    
    var presenter: MainPresenterProtocol?
    
    // MARK: - UI
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        subscribeNotify()
        presenter?.getOptionsModel()
        presenter?.getSaloonMockModel()
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
        contentView.delegate = self
    }
    
    private func checkIsUserLaunched() {
        if OnboardManager.shared.isUserFirstLaunch() {
            isFirstUserLaunch()
        }
    }
    
    private func isFirstUserLaunch() {
        let factory: DefaultVCFactory = VCFactory()
        let vc = factory.getViewController(for: .register)
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    private func subscribeNotify() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getNotifyAction(_:)),
                                               name: .showTabBar,
                                               object: nil)
    }
    
    // MARK: - Action
    
    @objc
    private func getNotifyAction(_ notification: Notification) {
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainViewController: MainViewDelegate {
    
    // MARK: - MainViewDelegate methods
    
    func showFilter() {
        AppRouter.shared.present(type: .filter)
    }
    
    func showSaloonDetail(saloon: SaloonMockModel) {
        AppRouter.shared.push(.saloonDetail(saloon))
    }
    
    func showSelectableMap(model: CommonModel) {
        AppRouter.shared.push(.selectableMap(model))
    }
    
    func showSearch(model: [SaloonMockModel]) {
        AppRouter.shared.presentSearch(type: .search(model)) { [weak self] model in
            guard let self = self else { return }
            if let index = self.presenter?.getSearchIndex(id: model.id) {
                self.contentView.scrollToItem(at: index)
            }
        }
    }
}

extension MainViewController: MainViewProtocol {
    
    // MARK: - MainViewProtocol methods
    
    func updateWithOptions(model: [OptionsModel]) {
        contentView.optionsModel = model
    }
    
    func updateWithSaloonMock(model: [SaloonMockModel]) {
        contentView.saloonMockModel = model
    }
    
    func updateWithFilter(model: [SaloonMockModel]) {
        contentView.saloonMockModel = model
    }
}

extension MainViewController: HideNavigationBar {}
