//
//  ServicesViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class ServicesViewController: BaseViewController<ServicesView> {

    // MARK: - Nested types

    enum Section {
        case single
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Service>

    // MARK: - Properties

    var dataSource: DataSource?

    var presenter: ServicesPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.service

        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func setupDataSource(model: [Service]) {
        dataSource = DataSource(tableView: contentView.tableView) {
            tableView, indexPath, item in
            let cell = tableView.dequeueCell(withType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = item.title
            return cell
        }
    }

    private func applySnapShot(model: [Service]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Service>()
        snapShot.appendSections([.single])
        snapShot.appendItems(model)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }

    private func subscribeDelegates() {
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }
}

extension ServicesViewController: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == AssetString.findInServices {
            contentView.searchBar.text = nil
        }
        contentView.searchBar.searchTextField.textColor = .black
    }
}

extension ServicesViewController: ServicesViewInput {

    // MARK: - ServicesViewInput methods

    func updateUI(model: [Service]) {
        setupDataSource(model: model)
        applySnapShot(model: model)
    }
}

extension ServicesViewController: UITableViewDelegate {}
