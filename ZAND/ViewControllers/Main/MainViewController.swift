//
//  File.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

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
        presenter?.getOptionsModel()
        presenter?.getSaloonMockModel()
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
        contentView.delegate = self
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
    
    func showSelectableMap(coordinates: String) {
        AppRouter.shared.push(.selectableMap(coordinates))
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
