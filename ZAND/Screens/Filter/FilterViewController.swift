//
//  FilterViewController.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit

final class FilterViewController: BaseViewController<FilterView> {

    // MARK: - Presenter

    var presenter: FilterPresenterOutput?

    var completionHandler: (([IndexPath: Bool], Bool) -> Void)?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }

    deinit {
        if presenter?.isFiltersEmpty() == true {
            completionHandler?([:], false)
        }
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.delegate = self
    }
}

extension FilterViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource mwthods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilterSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch FilterSection.init(rawValue: section) {
        case .filterOption:
            return presenter?.getModel(by: .filter).count ?? 0
        case .services:
            return presenter?.getModel(by: .options).count ?? 0
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch FilterSection.init(rawValue: indexPath.section) {
        case .filterOption:
            let filterCell = collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: FilterCell.self
            )

            let isCh = presenter?.selectFilters[indexPath] ?? false
            isCh ? (filterCell.isTapped = true) : (filterCell.isTapped = false)

            if let model = presenter?.getModel(by: .filter) {
                filterCell.configure(model: model[indexPath.item], indexPath: indexPath)
            }
            return filterCell
        case .services:
            let optionCell = collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: OptionCell.self
            )

            if let optionModel = presenter?.getModel(by: .options) {
                optionCell.configure(model: optionModel[indexPath.item], state: .onFilter)
            }

            let isCh = presenter?.selectFilters[indexPath] ?? false
            isCh ? (optionCell.isTapped = true) : (optionCell.isTapped = false)

            return optionCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension FilterViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch FilterSection.init(rawValue: indexPath.section) {
        case .filterOption:
            let cell = collectionView.cellForItem(at: indexPath) as? FilterCell

            if cell?.isTapped == true {
                cell?.isTapped = false
                presenter?.isNearestActive = false
                contentView.deselectRows(
                    indexPath: presenter?.selectFilters.compactMap({ $0.key }) ?? []
                )
                presenter?.selectFilters.removeAll()
            } else {
                cell?.isTapped = true
                presenter?.isNearestActive = true
            }
        case .services:
            let cell = collectionView.cellForItem(at: indexPath) as! OptionCell

            if cell.isTapped == false {
                cell.isTapped = true
                presenter?.selectFilters[indexPath] = true
                let unnecessaryIndexes = presenter?.selectFilters.filter({ $0.key != indexPath})
                for (index, _) in unnecessaryIndexes! {
                    presenter?.selectFilters[index] = false
                    if let cell = collectionView.cellForItem(at: index) as? OptionCell {
                        cell.isTapped = false
                    }
                }
            }
        default:
            break
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableView(
            for: indexPath,
            viewType: ReuseHeaderView.self,
            kind: .header
        )
        headerView.state = indexPath.section == 0 ? .filters : .services
        return headerView
    }
}

extension FilterViewController: FilerViewDelegate {

    // MARK: - FilerViewDelegate methods

    func clearFilterActions() {
        contentView.deselectRows(
            indexPath: presenter?.selectFilters.compactMap({ $0.key }) ?? []
        )
        presenter?.selectFilters.removeAll()
        presenter?.isNearestActive = false
        let cell = contentView.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? FilterCell
        cell?.isTapped = false
    }

    func applyButtonTap() {
        completionHandler?(presenter?.selectFiltersToTransfer ?? [:], presenter?.isNearestActive ?? false)
        AppRouter.shared.dismiss()
    }
}

extension FilterViewController: FilterViewInput {

    // MARK: - FilterViewInput methods

    func setSelectedFilters(contains: Bool) {
        contentView.isFilterSelected(isSelected: contains)
    }

    func updateButton(by emptyPoint: Bool) {
        contentView.updateButtons(isUpdate: emptyPoint)
    }
}
