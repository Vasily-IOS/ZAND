//
//  MainView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class MainView: BaseUIView {
    
    // MARK: - Closures
    
    private let searchClosure = {
        AppRouter.shared.present(type: .search)
    }
    
    // MARK: -
    
    var layoutBuilder: LayoutBuilderProtocol?
    
    // MARK: - Test Model
    
    private let optionsModel = OptionsModel.options
    private let saloonMockModel = SaloonMockModel.saloons
    
    // MARK: - UI
    
    private lazy var searchButton = SearchButton(handler: searchClosure)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: String(describing: OptionCell.self))
        collectionView.register(SaloonCell.self, forCellWithReuseIdentifier: String(describing: SaloonCell.self))
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(layoutBuilder: LayoutBuilderProtocol) {
        self.layoutBuilder = layoutBuilder
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
            switch MainSection.init(rawValue: section) {
            case .option:
                return self.layoutBuilder?.createSection(type: .option)
            case .beautySaloon:
                return self.layoutBuilder?.createSection(type: .beautySaloon)
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
        return MainSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch MainSection.init(rawValue: section) {
        case .option:
            return optionsModel.count
        case .beautySaloon:
            return saloonMockModel.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OptionCell.self), for: indexPath) as! OptionCell
        let saloonCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SaloonCell.self), for: indexPath)
        as! SaloonCell
        
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            optionCell.configure(model: optionsModel[indexPath.item], state: .onMain)
            return optionCell
        case .beautySaloon:
            saloonCell.configure(model: saloonMockModel[indexPath.item])
            return saloonCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            AppRouter.shared.present(type: .filter)
        }
        if indexPath.section == 1 {
            let model = saloonMockModel[indexPath.item]
            AppRouter.shared.push(.saloonDetail(model))
        }
    }
}
