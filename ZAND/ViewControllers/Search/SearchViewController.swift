//
//  SearchViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class SearchViewController: BaseViewController<SearchView> {
    
    // MARK: - Closures
    
    var completionHandler: ((SaloonMockModel) -> ())?
    
    // MARK: - Properties
    
    var presenter: SearchPresenter?
    
    // MARK: - UI
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeDelegate()
        presenter?.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    deinit {
        print("SearchViewController died")
    }
    
    // MARK: - Instance methods
    
    private func subscribeDelegate() {
        contentView.delegate = self
    }
}

extension SearchViewController: SearchViewProtocol {
    
    // MARK: - SearchViewProtocol methods
    
    func updateUI(with model: [SaloonMockModel]) {
        contentView.model = model
    }
}

extension SearchViewController: SearchViewDelegate {
    
    // MARK: - SearchViewDelegate methods
    
    func dismiss(value: SaloonMockModel) {
        completionHandler?(value)
        AppRouter.shared.dismiss()
    }
}

extension SearchViewController: HideNavigationBar {}
