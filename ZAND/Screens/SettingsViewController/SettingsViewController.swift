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

    var model: [SettingsMenuModel] = [] {
        didSet {
            self.presenter?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        setNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        presenter?.getData()
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }

    private func setNavBar() {
        title = StringsAsset.settings
    }
}

extension SettingsViewController: SettingsInput {

    // MARK: - SettingsInput methods

    func updateUI(model: [SettingsMenuModel]) {
        self.model = model
    }

    func reloadData() {
        contentView.collectionView.reloadData()
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
            return model.count
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
            cell.configure(model: model[indexPath.row])
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
