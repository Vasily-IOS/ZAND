//
//  FilterView.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

final class FilterView: BaseUIView {
    
    // MARK: - Properties
    
    var layoutBulder: DefaultLayoutBuilder?
   
    // MARK: - Model
    
    private let filterModel = FilterModel.filterModel
    private let optionModel = OptionsModel.optionWithoutFilterModel
    
    // MARK: - UI
    
    private let lineImage = UIImageView(image: ImageAsset.line_icon)
    private let viewFirstLabel = UILabel(.systemFont(ofSize: 20, weight: .bold), .black, StringsAsset.showFirst)
    
    private let applyButton = BottomButton(buttonText: .apply)
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.borderColor = UIColor.lightGreen.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = .mainGray
        cancelButton.setTitle(StringsAsset.reset, for: .normal)
        cancelButton.setTitleColor(.mainGreen, for: .normal)
        cancelButton.layer.cornerRadius = 15
        cancelButton.isHidden = true
        return cancelButton
    }()
    
    private lazy var buttonStackView = UIStackView(alignment: .fill,
                                                    arrangedSubviews: [
                                                        cancelButton,
                                                        applyButton
                                                    ],
                                                    axis: .horizontal,
                                                    distribution: .fillEqually,
                                                    spacing: 16)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilterOptionCell.self,
                                forCellWithReuseIdentifier: String(describing: FilterOptionCell.self))
        collectionView.register(OptionCell.self,
                                forCellWithReuseIdentifier: String(describing: OptionCell.self))
        collectionView.register(ReuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: ReuseHeaderView.self))
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    // MARK: - Initializers
    
    init(layout: DefaultLayoutBuilder) {
        super.init(frame: .zero)
        self.layoutBulder = layout
    }

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
        subscribeDelegate()
        addTargets()
    }
    
    // MARK: - Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch FilterSection.init(rawValue: section) {
            case .filterOption:
                return self?.layoutBulder?.createSection(type: .filterOption)
            case .services:
                return self?.layoutBulder?.createSection(type: .services)
            default:
                return nil
            }
        }
        return layout
    }
    
    // MARK: - Action
    
    @objc
    private func clearFiltersAction() {
        buttonStackView.subviews[0].isHidden = true
        deselectAllRows()
    }
    
    // MARK: -
    
    private func deselectAllRows() {
        let selectedItems = collectionView.indexPathsForSelectedItems ?? []
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension FilterView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([lineImage, viewFirstLabel, collectionView,
                     buttonStackView])
        
        lineImage.snp.makeConstraints { make in
            make.top.equalTo(self).offset(3)
            make.centerX.equalTo(self)
        }
        
        viewFirstLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(35)
            make.left.equalTo(self).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(viewFirstLabel.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(self.snp.bottom).inset(40)
        }
    }
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
    
    private func addTargets() {
        cancelButton.addTarget(self, action: #selector(clearFiltersAction), for: .touchUpInside)
    }
}

extension FilterView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilterSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch FilterSection.init(rawValue: section) {
        case .filterOption:
            return filterModel.count
        case .services:
            return optionModel.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterOptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterOptionCell.self),
                                                                  for: indexPath) as! FilterOptionCell
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OptionCell.self),
                                                                  for: indexPath) as! OptionCell
        switch FilterSection.init(rawValue: indexPath.section) {
        case .filterOption:
            filterOptionCell.configure(model: filterModel[indexPath.item], indexPath: indexPath)
            return filterOptionCell
        case .services:
            optionCell.configure(model: optionModel[indexPath.item], state: .onFilter)
            return optionCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension FilterView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch FilterSection.init(rawValue: indexPath.section) {
        case .filterOption:
            print(1)
        case .services:
            buttonStackView.subviews[0].isHidden = false
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: String(describing: ReuseHeaderView.self),
                                                                         for: indexPath) as! ReuseHeaderView
        headerView.state = .services
        return headerView
    }
}
