//
//  ServicesViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class ServicesViewController: BaseViewController<ServicesView>, UITableViewDelegate {

    // MARK: - Properties

    var presenter: ServicesPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.service

        subscribeDelegates()
        hideBackButtonTitle()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }
}

extension ServicesViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.model.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter?.model[section]

        if section?.isOpened == true {
            return (section?.services.count ?? 0) + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(withType: CategoryCell.self, for: indexPath)
            if let categories = presenter?.model[indexPath.section] {
                cell.configure(model: categories)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(withType: ServiceCell.self, for: indexPath)
            cell.configure(model: presenter?.model[indexPath.section].services[indexPath.row - 1])
            return cell
        }
    }
}

extension ServicesViewController {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter?.model[indexPath.section].isOpened = !(presenter?.model[indexPath.section].isOpened)!
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            let staffIDs = presenter?.model[indexPath.section].services[indexPath.row - 1].staff.map({ $0.id }) ?? []

//            print("Service number: \(presenter?.model[indexPath.section].services[indexPath.row - 1].id ?? 0), service gives \(staffIDs) people")

            let view = StaffView()
            let vc = StaffViewController(contentView: view)
            let network: HTTP = APIManager()
            let presenter = StaffPresenter(
                view: vc,
                saloonID: presenter?.saloonID ?? 0,
                network: network,
                staffIDs: staffIDs)
            vc.presenter = presenter
            navigationController?.pushViewController(vc, animated: true)
        }
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

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }
}

extension ServicesViewController: HideBackButtonTitle {}
