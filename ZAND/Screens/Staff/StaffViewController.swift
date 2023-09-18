//
//  StaffViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class StaffViewController: BaseViewController<StaffView> {

    // MARK: - Properties

    var presenter: StaffPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.fetchStaff()
        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

extension StaffViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.staff.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = presenter?.staff[indexPath.row].name
        return cell
    }
}

extension StaffViewController: UITableViewDelegate {


}

extension StaffViewController: StaffViewInput {

    // MARK: - ServicesViewInput methods

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }
}
