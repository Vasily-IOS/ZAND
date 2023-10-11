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

    var completionHandler: (([IndexPath: Bool]) -> Void)?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }
    
    deinit {
        print("FilterViewController died")

        if let filters = presenter?.selectFilters {
            completionHandler?(filters)
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

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch FilterSection.init(rawValue: section) {
        case .services:
            return presenter?.getModel(by: .options).count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterOptionCell = collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: FilterOptionCell.self
        )
        let optionCell = collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: OptionCell.self
        )

        switch FilterSection.init(rawValue: indexPath.section) {
        case .services:
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
        case .services:
            contentView.isFilterSelected(isSelected: true)
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
        headerView.state = .services
        return headerView
    }
}

extension FilterViewController: FilerViewDelegate {

    // MARK: - FilerViewDelegate methods

    func clearFilterActions() {
        contentView.buttonStackView.subviews[0].isHidden = true
        contentView.deselectRows(indexPath: presenter?.selectFilters.compactMap({ $0.key }) ?? [])
        presenter?.selectFilters.removeAll()
    }
}

extension FilterViewController: FilterViewInput {

    // MARK: - FilterViewInput methods

    func filterAlreadyContains(contains: Bool) {
        contentView.isFilterSelected(isSelected: contains)
    }
}
