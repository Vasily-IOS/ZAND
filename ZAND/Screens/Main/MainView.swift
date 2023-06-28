//
//  MainView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func showFilter()
    func showSaloonDetail(saloon: SaloonMockModel)
    func showSelectableMap(model: CommonModel)
    func showSearch(model: [SaloonMockModel])
}

final class MainView: BaseUIView {
    
    // MARK: - Closures
    
    private lazy var searchClosure = { [weak self] in
        guard let self = self else { return }
        self.showSearch()
    }
    
    private lazy var viewOnMapClosure = { [weak self] (model: CommonModel) -> () in
        guard let self else { return }

        self.showSelectableMap(model: model)
    }
    
    private lazy var favouritesHandler = { [weak self] (indexPath: IndexPath) -> () in
        guard let self = self else { return }
        self.changeHeartAppearence(by: indexPath)
        VibrationManager.shared.vibrate(for: .success)
    }
    
    // MARK: -
    
    weak var delegate: MainViewDelegate?

    private let layoutBuilder: DefaultMainLayout
    
    // MARK: - Test Model
    
    var optionsModel: [OptionsModel] = []
    var saloonMockModel: [SaloonMockModel] = []
    
    // MARK: - UI
    
    private lazy var searchButton = SearchButton(handler: searchClosure)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.register(cellType: OptionCell.self)
        collectionView.register(cellType: SaloonCell.self)
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(layoutBuilder: DefaultMainLayout) {
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
    
    // MARK: - Instance methods
    
    func scrollToItem(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    // MARK: - Private
    
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
        let layout = UICollectionViewCompositionalLayout
        { (section, _) in
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
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func changeHeartAppearence(by indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! SaloonCell
        cell.isInFavourite = !cell.isInFavourite
    }
    
    private func showSelectableMap(model: CommonModel) {
        delegate?.showSelectableMap(model: model)
    }
    
    private func showSearch() {
        self.delegate?.showSearch(model: self.saloonMockModel)
    }
}

extension MainView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
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
        let optionCell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCell.self)
        let saloonCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonCell.self)
        
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            optionCell.configure(model: optionsModel[indexPath.item], state: .onMain)
            return optionCell
        case .beautySaloon:
            saloonCell.configure(model: saloonMockModel[indexPath.item], indexPath: indexPath)
            saloonCell.viewOnMapHandler = viewOnMapClosure
            saloonCell.favouritesHandler = favouritesHandler
            return saloonCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch MainSection.init(rawValue: indexPath.section) {
        case .option:
            if indexPath.section == 0 && indexPath.item == 0 {
                delegate?.showFilter()
            }
        case .beautySaloon:
            let model = saloonMockModel[indexPath.item]
            delegate?.showSaloonDetail(saloon: model)
        default:
            break
        }
    }
}