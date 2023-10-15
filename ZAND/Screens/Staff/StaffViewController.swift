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
        
        subscribeDelegates()
        hideBackButtonTitle()
    }

    deinit {
        print("StaffViewController died")
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

        guard let viewModel = presenter?.viewModel else { return }
        viewModel.staffID = presenter?.fetchedStaff[indexPath.section].id ?? 0
        viewModel.employeeCommon = presenter?.fetchedStaff[indexPath.section]

        switch viewModel.bookingType {
        case .service:
            AppRouter.shared.pushCreateRecord(.timeTable(viewModel: viewModel))
        case .staff:
            AppRouter.shared.pushCreateRecord(.services(viewModel: viewModel))
        case .default:
            break
        }
    }
}

extension StaffViewController: StaffViewInput {

    // MARK: - ServicesViewInput methods

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }

    func showIndicator(_ isShow: Bool) {
        contentView.showActivity(isShow)
    }
}

extension StaffViewController: HideBackButtonTitle {}
