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

    typealias DataSource = UITableViewDiffableDataSource<Section, Saloon>

    // MARK: - Properties

    var dataSource: DataSource?
    
    var completionHandler: ((Saloon) -> ())?
    
    var presenter: SearchPresenter?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        subscribeNotifications()
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentView.searchBar.text?.isEmpty == true {
            contentView.endEditing()
        }
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        contentView.tableView.contentSize.height += keyboardSize.height
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        contentView.tableView.contentSize.height -= (keyboardSize.height)
    }
    
    private func subscribeDelegate() {
        contentView.delegate = self
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }

    private func setupDataSource(model: [Saloon]) {
        dataSource = DataSource(tableView: contentView.tableView) {
            tableView, indexPath, item in
            let cell = tableView.dequeueCell(withType: SearchCell.self, for: indexPath)
            cell.configure(model: item)
            return cell
        }
    }

    private func applySnapShot(model: [Saloon]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Saloon>()
        snapShot.appendSections([.single])
        snapShot.appendItems(model)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }

    private func dismiss(value: Saloon) {
        completionHandler?(value)
        AppRouter.shared.dismiss()
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
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
    
    func updateUI(with model: [Saloon]) {
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
