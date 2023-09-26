//
//  TimetableViewController.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

final class TimetableViewController: BaseViewController<TimetableView> {

    // MARK: - Properties

    var selectedDays: [IndexPath: Bool] = [:]

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

    private func deselectAllRows(collectionView: UICollectionView, in section: Int) {
        for item in 0..<collectionView.numberOfItems(inSection: section) {
            let index = IndexPath(row: item, section: section)
            collectionView.deselectItem(at: index, animated: false)
        }
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
            return presenter?.bookTimeModel.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch TimetableSection.init(rawValue: indexPath.section) {
        case .day:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DayCell.self)
            cell.configure(model: (presenter?.workingRangeModel[indexPath.item])!)

            let isCh = selectedDays[indexPath] ?? false
            isCh ? (cell.isChoosen = true) : (cell.isChoosen = false)

            return cell
        case .time:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimeCell.self)
            cell.configure(model: (presenter?.bookTimeModel[indexPath.item])!)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension TimetableViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch TimetableSection.init(rawValue: indexPath.section) {
        case .day:
            let cell = collectionView.cellForItem(at: indexPath) as! DayCell

            if cell.isChoosen == false {
                cell.isChoosen = true
                selectedDays[indexPath] = true

                let test = selectedDays.filter({ $0.key != indexPath})

                for (index, _) in test {
//                    guard index == nil else { return }
                    selectedDays[index] = false
                    print(index)
                    if let cell = collectionView.cellForItem(at: index) as? DayCell {
                        cell.isChoosen = false

                    }


                }
            } else {
                cell.isChoosen = false
                selectedDays[indexPath] = false
            }

            presenter?.fetchBookTimes(
                date: presenter?.workingRangeModel[indexPath.item].dateString ?? ""
            )

        case .time:
            let cell = collectionView.cellForItem(at: indexPath) as! TimeCell
            cell.isSelected = !cell.isSelected
            print(presenter?.bookTimeModel[indexPath.item].datetime ?? "")
        default:
            break
        }
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

    func reloadData() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }

    func reloadSection() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
}
