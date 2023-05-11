//
//  FavouritesCell.swift
//  ZAND
//
//  Created by Василий on 03.05.2023.
//

import UIKit
import SnapKit

final class FavouritesCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        return saloonImage
    }()
    
    private let saloonName: UILabel = {
        let saloonName = UILabel()
        saloonName.font = .systemFont(ofSize: 12, weight: .bold)
        return saloonName
    }()
    
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)
    private let favouritesStarImage = UIImageView(image: UIImage(named: "star_icon"))
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 12)
        return ratingLabel
    }()
    
    // MARK: - Initializers

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        setViews()
    }
    
    func configure(model: SaloonMockModel) {
        saloonImage.image = model.image
        saloonName.text = model.name
        ratingLabel.text = "\(model.rating)"
    }
}

extension FavouritesCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, saloonName, viewOnMapButton,
                     favouritesStarImage, ratingLabel])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(101)
        }
        
        saloonName.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(3)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(110)
        }
        
        viewOnMapButton.snp.makeConstraints { make in
            make.top.equalTo(saloonName.snp.bottom).offset(4)
            make.left.equalTo(saloonName)
            make.bottom.equalTo(self).inset(2)
        }
        
        favouritesStarImage.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(8)
            make.right.equalTo(self).inset(10)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(favouritesStarImage)
            make.right.equalTo(self).inset(20)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }
}
