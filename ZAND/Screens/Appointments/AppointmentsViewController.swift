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

    // MARK: - Closures

    private let mapHandler = { model in
        AppRouter.shared.push(.selectableMap(model))
    }

    // MARK: - Properties

    typealias DataSource = UITableViewDiffableDataSource<Section, AppointmentsModel>

    var dataSource: DataSource?

    var presenter: AppointmentsPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeDelegate()
        presenter?.getData(by: .upcoming)
    }

    // MARK: - Instance methods

    private func setupDataSource(model: [AppointmentsModel]) {
        dataSource = DataSource(tableView: contentView.tableView) {
            [weak self] tableView, indexPath, item  in
            let cell = tableView.dequeueCell(withType: AppoitmentsCell.self, for: indexPath)
            cell.configure(model: item)
            cell.mapHandler = self?.mapHandler
            return cell
        }
    }

    private func applySnapshot(model: [AppointmentsModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AppointmentsModel>()
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

    func updateUI(model: [AppointmentsModel]) {
        setupDataSource(model: model)
        applySnapshot(model: model)
    }
}

extension AppointmentsViewController: AppointmentsDelegate {

    // MARK: - AppointmentsDelegate methods

    func changeModel(by type: AppointmentType) {
        presenter?.getData(by: type)
    }
}
