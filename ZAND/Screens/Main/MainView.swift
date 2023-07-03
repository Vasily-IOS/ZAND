//
//  MainView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func showSearch()
}

final class MainView: BaseUIView {

    // MARK: - Properties
    
    weak var delegate: MainViewDelegate?

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.register(cellType: OptionCell.self)
        collectionView.register(cellType: SaloonCell.self)
        return collectionView
    }()

    private lazy var searchButton = SearchButton()

    private let layoutBuilder: DefaultMainLayout
    
    // MARK: - Initializers
    
    init(layoutBuilder: DefaultMainLayout) {
        self.layoutBuilder = layoutBuilder
        super.init(frame: .zero)

        searchButton.tapHandler = { [weak self] in
            self?.delegate?.showSearch()
        }
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }

    func changeHeartAppearence(by indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! SaloonCell
        cell.isInFavourite = !cell.isInFavourite
    }

    func scrollToItem(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

extension MainView {
    
    // MARK: - Instance methods

    private func setViews() {
        backgroundColor = .mainGray

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
        let layout = UICollectionViewCompositionalLayout
        { section, _ in
            switch MainSection.init(rawValue: section) {
            case .option:
                return self.layoutBuilder.createSection(type: .option)
            case .beautySaloon:
                return self.layoutBuilder.createSection(type: .beautySaloon)
            default:
                return nil
            }
        }
        return layout
    }
}
