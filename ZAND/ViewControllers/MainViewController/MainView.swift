//
//  MainView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case option
    case beautySaloon
}

final class MainView: BaseUIView {
    
    // MARK: - Closures
    
    private let searchClosure = {
        AppRouter.shared.present(type: .search)
    }
    
    // MARK: - Test Model
    
    private var model = OptionsModel.options
    
    // MARK: - Properties
    
    private lazy var searchButton = SearchButton(handler: searchClosure)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: String(describing: OptionCell.self))
        return collectionView
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
        subscribeDelegate()
    }
}

extension MainView {
    
    private func setViews() {
        addSubviews([searchButton, collectionView])
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(25)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            switch Section.init(rawValue: section) {
            case .option:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 10)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(90),
                    heightDimension: .absolute(110))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                return section
            case .beautySaloon:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0,
                                                              bottom: 8, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0,
                                                                bottom: 0, trailing: 0)
                
                return section
            default:
                return nil
            }
        }
        return layout
    }
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}

extension MainView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section.init(rawValue: section) {
        case .option:
            return model.count
        case .beautySaloon:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
       let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OptionCell.self), for: indexPath) as! OptionCell
        
        switch Section.init(rawValue: indexPath.section) {
        case .option:
            optionCell.configure(model: model[indexPath.item])
            return optionCell
        case .beautySaloon:
            cell.backgroundColor = .green
            cell.layer.cornerRadius = 15
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainView: UICollectionViewDelegate {
    
}
