//
//  AppointmentsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class AppointmentsViewController: BaseViewController<AppointemtsView> {

    // MARK: - Nested types

    enum Section {
        case appointments
    }

    // MARK: - Properties

    typealias DataSource = UITableViewDiffableDataSource<Section, UIAppointmentModel>

    var dataSource: DataSource?

    var presenter: AppointmentsPresenterOutput?

    private let cancelButtonHandler = { indexPath in
        print(indexPath)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeDelegate()
    }

    // MARK: - Instance methods

    private func setupDataSource(model: [UIAppointmentModel]) {
        dataSource = DataSource(tableView: contentView.tableView)
        { [weak self] tableView, indexPath, item  in
            let cell = tableView.dequeueCell(withType: AppoitmentsCell.self, for: indexPath)
            cell.configure(item)
            cell.indexPath = indexPath
            cell.cancelButtonHandler = self?.cancelButtonHandler
            return cell
        }
    }

    private func applySnapshot(model: [UIAppointmentModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, UIAppointmentModel>()
        snapShot.appendSections([.appointments])
        snapShot.appendItems(model)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

extension AppointmentsViewController {
    
    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }
}

extension AppointmentsViewController: AppointmentsInput {

    // MARK: - AppointmentsInput methods

    func updateUI(model: [UIAppointmentModel]) {
        setupDataSource(model: model)
        applySnapshot(model: model)
    }

    func showIndicator(_ isShow: Bool) {
        contentView.showActivity(isShow)
    }
}

extension AppointmentsViewController: AppointmentsDelegate {

    // MARK: - AppointmentsDelegate methods

    func changeModel(by type: AppointmentType) {
        presenter?.getData(by: type)
    }
}
