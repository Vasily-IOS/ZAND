//
//  SettingsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class MyDetailsViewController: BaseViewController<MyDetailsView> {

    // MARK: - Properties

    var presenter: MyDetailsPresenterOutput?

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

extension MyDetailsViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MyDetailsSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch MyDetailsSection.init(rawValue: section) {
        case .data:
            return presenter?.getModel().count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch MyDetailsSection.init(rawValue: indexPath.section) {
        case .data:
            let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                          cellType: DataCell.self)
            if let singleModel = presenter?.getModel() {
                cell.configure(model: singleModel[indexPath.row])
            }

            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MyDetailsViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = contentView.collectionView.dequeueReusableView(for: indexPath,
                                                            viewType: ReuseHeaderView.self,
                                                            kind: .header)
        switch MyDetailsSection.init(rawValue: indexPath.section) {
        case .data:
            headerView.state = .data
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension MyDetailsViewController: MyDetailsInput {}
