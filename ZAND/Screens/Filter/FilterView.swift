//
//  FilterView.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

protocol FilerViewDelegate: AnyObject {
    func clearFilterActions()
}

final class FilterView: BaseUIView {
    
    // MARK: - Properties

    weak var delegate: FilerViewDelegate?
    
    private let layoutBulder: DefaultFilterLayout

    // MARK: - UI

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: FilterOptionCell.self)
        collectionView.register(cellType: OptionCell.self)
        collectionView.register(view: ReuseHeaderView.self)

        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    lazy var buttonStackView = UIStackView(alignment: .fill,
                                                    arrangedSubviews: [
                                                        cancelButton,
                                                        applyButton
                                                    ],
                                                    axis: .horizontal,
                                                    distribution: .fillEqually,
                                                    spacing: 16)

    
    private let lineImage = UIImageView(image: ImageAsset.line_icon)

    private let viewFirstLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                         .black,
                                         StringsAsset.showFirst)
    
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

    // MARK: - Initializers
    
    init(layout: DefaultFilterLayout) {
        self.layoutBulder = layout
        super.init(frame: .zero)
    }

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        addTarget()
    }
    
    // MARK: - Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch FilterSection.init(rawValue: section) {
            case .filterOption:
                return self?.layoutBulder.createSection(type: .filterOption)
            case .services:
                return self?.layoutBulder.createSection(type: .services)
            default:
                return nil
            }
        }
        return layout
    }
    
    // MARK: - Action
    
    @objc
    private func clearFiltersAction() {
        delegate?.clearFilterActions()
    }
    
    // MARK: - Instance methods
    
    func deselectAllRows() {
        let selectedItems = collectionView.indexPathsForSelectedItems ?? []
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension FilterView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .white
        
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

    private func addTarget() {
        cancelButton.addTarget(self,
                               action: #selector(clearFiltersAction),
                               for: .touchUpInside)
    }
}
