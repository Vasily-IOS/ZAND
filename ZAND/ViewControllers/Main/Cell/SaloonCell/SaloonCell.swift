//
//  SaloonCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        return saloonImage
    }()
    
    private let saloonDescriptionLabel = UILabel(.systemFont(ofSize: 20))
    private let categoryLabel = UILabel(.systemFont(ofSize: 12), .textGray)
    private let adressLabel = UILabel(.systemFont(ofSize: 12))
    
    private let favouritesButton: UIButton = {
        let favouritesButton = UIButton()
        favouritesButton.setImage(UIImage(named: "fav_icon"), for: .normal)
        return favouritesButton
    }()
    
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)
    
    private let starImage: UIImageView = {
        let starImage = UIImageView()
        starImage.image = UIImage(named: "star_icon")
        return starImage
    }()
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 12)
        return ratingLabel
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        setViews()
    }
    
    // MARK: - Configuration
    
    func configure(model: SaloonMockModel) {
        saloonImage.image = model.image
        saloonDescriptionLabel.text = model.name
        categoryLabel.text = model.category.name
        adressLabel.text = model.adress
        ratingLabel.text = "\(model.rating)"
    }
}

extension SaloonCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, saloonDescriptionLabel, categoryLabel, adressLabel,
                     favouritesButton, viewOnMapButton, starImage, ratingLabel])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(214)
        }
        
        saloonDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(12)
            make.left.equalTo(self).offset(10)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(saloonDescriptionLabel.snp.bottom).offset(1)
        }
        
        adressLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(categoryLabel.snp.bottom).offset(6)
            make.bottom.equalTo(self).inset(12)
        }
        
        favouritesButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        viewOnMapButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(10)
            make.height.equalTo(15)
        }
        
        starImage.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.top.equalTo(saloonImage.snp.bottom).offset(12)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.right.equalTo(starImage.snp.right).inset(10)
            make.centerY.equalTo(starImage)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}
