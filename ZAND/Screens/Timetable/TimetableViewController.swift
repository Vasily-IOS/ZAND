//
//  TimetableViewController.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

final class TimetableViewController: BaseViewController<TimetableView> {

    // MARK: - Properties

    var presenter: TimetablePresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.selectDateAndTime

        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
}

extension TimetableViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TimetableSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TimetableSection.init(rawValue: section) {
        case .day:
            return presenter?.workingRangeModel.count ?? 0
        case .time:
            return 10
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DayCell.self)
        switch TimetableSection.init(rawValue: indexPath.section) {
        case .day:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DayCell.self)
            cell.configure(model: (presenter?.workingRangeModel[indexPath.item])!)
            return cell
        case .time:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimeCell.self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension TimetableViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch TimetableSection.init(rawValue: indexPath.section) {
        case .time:
            let headerView = collectionView.dequeueReusableView(
                for: indexPath,
                viewType: ReuseHeaderView.self,
                kind: .header
            )
            headerView.state = .time
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension TimetableViewController: TimetableInput {

    // MARK: - TimetableInput methods

}
