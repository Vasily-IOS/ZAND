//
//  DescriptionShowcaseView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

final class DescriptionShowcaseView: BaseUIView {
    
    // MARK: - Model
    
    private let model: SaloonMockModel
    
    // MARK: - UI
    
    private let topDescriptionLabel = UILabel(.systemFont(ofSize: 20, weight: .bold), .black, Strings.description)
    private let showCaseLabel = UILabel(.systemFont(ofSize: 20, weight: .bold), .black, Strings.showCase)
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCaseItemCell.self,
                                forCellWithReuseIdentifier: String(describing: ShowCaseItemCell.self))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(model: SaloonMockModel) {
        self.model = model
        super.init(frame: .zero)
        configure(model: model)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
        subscribeDelegate()
    }
    
    private func configure(model: SaloonMockModel) {
        descriptionLabel.text = model.description
    }
}

extension DescriptionShowcaseView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([topDescriptionLabel, descriptionLabel, showCaseLabel, collectionView])
        
        topDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(22)
            make.left.equalTo(self).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topDescriptionLabel.snp.bottom).offset(20)
            make.left.equalTo(topDescriptionLabel)
            make.right.equalTo(self).inset(38)
        }
        
        showCaseLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.equalTo(topDescriptionLabel)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(showCaseLabel.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(160)
            make.bottom.equalTo(self).inset(30)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension DescriptionShowcaseView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCaseItemCell.self),
                                                      for: indexPath) as! ShowCaseItemCell
        return cell
    }
}

extension DescriptionShowcaseView: UICollectionViewDelegate {}

extension DescriptionShowcaseView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 184, height: collectionView.frame.size.height)
    }
}
