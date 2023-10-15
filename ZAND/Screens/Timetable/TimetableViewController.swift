//
//  TimetableViewController.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

final class TimetableViewController: BaseViewController<TimetableView> {

    // MARK: - Properties

    // to presenter
    var selectedDays: [IndexPath: Bool] = [[0,0]:true]

    var presenter: TimetablePresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.selectDateAndTime

        subscribeDelegates()
        hideBackButtonTitle()
    }

    deinit {
        print("TimetableViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.delegate = self
    }

    private func showAlert() {
        let alertController = UIAlertController(
            title: AssetString.chooseTime,
            message: nil,
            preferredStyle: .alert)
        let understandAction = UIAlertAction(title: AssetString.ok, style: .cancel)
        alertController.addAction(understandAction)
        present(alertController, animated: true)
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
            guard let viewModel = presenter?.viewModel else { return }
            viewModel.bookTime = nil

            let cell = collectionView.cellForItem(at: indexPath) as! DayCell

            if cell.isChoosen == false {
                cell.isChoosen = true
                selectedDays[indexPath] = true
                let unnecessaryIndexes = selectedDays.filter({ $0.key != indexPath})
                for (index, _) in unnecessaryIndexes {
                    selectedDays[index] = false
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
            presenter?.updateDateLabel(date: (presenter?.workingRangeModel[indexPath.item].date)!)
            
        case .time:
            let cell = collectionView.cellForItem(at: indexPath) as! TimeCell
            cell.isSelected = !cell.isSelected

            if let viewModel = presenter?.viewModel {
                viewModel.bookTime = presenter?.bookTimeModel[indexPath.item]
            }

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

    func updateDate(date: String) {
        contentView.setMonth(month: date)
    }

    func showIndicator(_ isShow: Bool) {
        contentView.showActivity(isShow)
    }
}

extension TimetableViewController: TimetableViewDelegate {

    // MARK: - TimetableViewDelegate methods

    func navigateToConfirmation() {
        if presenter?.viewModel.bookTime == nil {
            showAlert()
        } else {
            guard let viewModel = presenter?.viewModel else { return }
            viewModel.build()

            let realm: RealmManager = RealmManagerImpl()
            let network: APIManager = APIManagerImpl()
            let view = ConfirmationView()
            let vc = ConfirmationViewController(contentView: view)
            let presenter = ConfirmationPresenter(
                view: vc,
                viewModel: viewModel,
                network: network,
                realm: realm
            )
            vc.presenter = presenter

            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TimetableViewController: HideBackButtonTitle {}
