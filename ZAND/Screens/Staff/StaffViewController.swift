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

        title = AssetString.staff
        
        subscribeDelegates()
        hideBackButtonTitle()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

extension StaffViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.fetchedStaff.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: StaffCell.self, for: indexPath)
        cell.configure(model: (presenter?.fetchedStaff[indexPath.section])!)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
}

extension StaffViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let contentView = TimetableView()
        let view = TimetableViewController(contentView: contentView)
        let network: HTTP = APIManager()
        let presenter = TimetablePresenter(
            view: view,
            network: network,
            saloonID: presenter?.saloonID ?? 0,
            staffID: presenter?.fetchedStaff[indexPath.row].id ?? 0)
        view.presenter = presenter
        navigationController?.pushViewController(view, animated: true)
    }
}

extension StaffViewController: StaffViewInput {

    // MARK: - ServicesViewInput methods

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }
}

extension StaffViewController: HideBackButtonTitle {}
