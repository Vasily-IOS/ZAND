//
//  TimetableView.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit
import SnapKit

final class TimetableView: BaseUIView {

    // MARK: - Properties

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(cellType: DayCell.self)
        collectionView.register(cellType: TimeCell.self)
        collectionView.register(view: ReuseHeaderView.self)
        return collectionView
    }()

    private let monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.font = .systemFont(ofSize: 18, weight: .bold)
        monthLabel.text = "Cентябрь"
        return monthLabel
    }()

    private let layout: DefaultTimetableLayout

    // MARK: - Initializers

    init(layout: DefaultTimetableLayout) {
        self.layout = layout

        super.init(frame: .zero)
    }

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        addSubviews([monthLabel, collectionView])

        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.left.equalTo(monthLabel)
            make.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            guard let self else { return nil }

            switch TimetableSection.init(rawValue: section) {
            case .day:
                return self.layout.createSection(type: .day)
            case .time:
                return self.layout.createSection(type: .time)
            default:
                return nil
            }
        }
        return layout
    }
}
