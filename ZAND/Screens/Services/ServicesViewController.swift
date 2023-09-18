//
//  ServicesViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class ServicesViewController: BaseViewController<ServicesView> {

    // MARK: - Properties

    var presenter: ServicesPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.showServices()
        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

extension ServicesViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.services.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = presenter?.services[indexPath.row].title
        return cell
    }
}

extension ServicesViewController: UITableViewDelegate {}

extension ServicesViewController: ServicesViewInput {

    // MARK: - ServicesViewInput methods

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }
}
