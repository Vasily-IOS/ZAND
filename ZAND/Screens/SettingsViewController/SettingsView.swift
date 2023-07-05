//
//  SettingsView.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class SettingsView: BaseUIView {
    
    // MARK: - Properties
    
    private let layout: DefaultSettingsLayout

    // MARK: - UI
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.isScrollEnabled = false
        collectionView.register(cellType: DataCell.self)
        collectionView.register(cellType: PushCell.self)
        collectionView.register(view: ReuseHeaderView.self)
        return collectionView
    }()

    // MARK: - Initializers
    
    init(layout: DefaultSettingsLayout) {
        self.layout = layout

        super.init(frame: .zero)
    }

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }
}

extension SettingsView {
    
    // MARK: - Instance methods

    private func setViews() {
        backgroundColor = .mainGray

        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(self).offset(150)
            make.bottom.equalTo(self)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            switch SettingsSection.init(rawValue: section) {
            case .data:
                return self.layout.createSection(type: .data)
            case .pushes:
                return self.layout.createSection(type: .pushes)
            default:
                return nil
            }
        }
        return layout
    }
}
