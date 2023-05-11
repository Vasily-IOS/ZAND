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
    
    var layout: DefaultSettingsLayout
    
    private let model = SettingsMenuModel.model
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.isScrollEnabled = false
        collectionView.register(DataCell.self, forCellWithReuseIdentifier: String(describing: DataCell.self))
        collectionView.register(PushCell.self, forCellWithReuseIdentifier: String(describing: PushCell.self))
        collectionView.register(ReuseHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: ReuseHeader.self))
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
        setBackgroundColor()
        subscribeDelegate()
    }
}

extension SettingsView {
    
    // MARK: - Instance methods
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func setViews() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(self).offset(150)
            make.bottom.equalTo(self)
        }
    }
    
    private func subscribeDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            switch SettingsState.init(rawValue: section) {
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

extension SettingsView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SettingsState.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SettingsState.init(rawValue: section) {
        case .data:
            return model.count
        case .pushes:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SettingsState.init(rawValue: indexPath.section) {
        case .data:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DataCell.self),
                                                          for: indexPath) as! DataCell
            cell.configure(model: model[indexPath.row])
            return cell
        case .pushes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PushCell.self),
                                                          for: indexPath) as! PushCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension SettingsView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: String(describing: ReuseHeader.self),
                                                                         for: indexPath) as! ReuseHeader
        switch SettingsState.init(rawValue: indexPath.section) {
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
