//
//  SearchViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class SearchViewController: BaseViewController<SearchView> {

    // MARK: - Nested types

    enum Section {
        case single
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, SaloonMockModel>

    var dataSource: DataSource?
    
    // MARK: - Closures
    
    var completionHandler: ((SaloonMockModel) -> ())?
    
    // MARK: - Properties
    
    var presenter: SearchPresenter?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        presenter?.updateUI()
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
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }

    private func setupDataSource(model: [SaloonMockModel]) {
        dataSource = DataSource(tableView: contentView.tableView) {
            tableView, indexPath, item in
            let cell = tableView.dequeueCell(withType: SearchCell.self, for: indexPath)
            cell.configure(model: item)
            return cell
        }
    }

    private func applySnapShot(model: [SaloonMockModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, SaloonMockModel>()
        snapShot.appendSections([.single])
        snapShot.appendItems(model)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }

    private func dismiss(value: SaloonMockModel) {
        completionHandler?(value)
        AppRouter.shared.dismiss()
    }
}

extension SearchViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = presenter?.currentModel {
            dismiss(value: model[indexPath.row])
        }
        contentView.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == AssetString.where_wanna_go {
            contentView.searchBar.text = nil
        }
        contentView.searchBar.searchTextField.textColor = .black
    }
}

extension SearchViewController: SearchViewInput {
    
    // MARK: - SearchViewProtocol methods
    
    func updateUI(with model: [SaloonMockModel]) {
        setupDataSource(model: model)
        applySnapShot(model: model)
    }
}

extension SearchViewController: SearchViewDelegate {

    // MARK: - SearchViewDelegate methods

    func dismiss() {
        AppRouter.shared.dismiss()
    }
}

extension SearchViewController: HideNavigationBar {}
