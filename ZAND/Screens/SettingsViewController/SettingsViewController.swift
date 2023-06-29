//
//  SettingsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsView> {

    // MARK: - Properties

    var presenter: SettingsPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
}

extension SettingsViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SettingsSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch SettingsSection.init(rawValue: section) {
        case .data:
            return presenter?.getModel().count ?? 0
        case .pushes:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SettingsSection.init(rawValue: indexPath.section) {
        case .data:
            let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                          cellType: DataCell.self)
            if let singleModel = presenter?.getModel() {
                cell.configure(model: singleModel[indexPath.row])
            }

            return cell
        case .pushes:
            let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                          cellType: PushCell.self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension SettingsViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = contentView.collectionView.dequeueReusableView(for: indexPath,
                                                            viewType: ReuseHeaderView.self,
                                                            kind: .header)
        switch SettingsSection.init(rawValue: indexPath.section) {
        case .data:
            headerView.state = .data
            return headerView
        case .pushes:
            headerView.state = .pushes
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension SettingsViewController: SettingsInput {}
