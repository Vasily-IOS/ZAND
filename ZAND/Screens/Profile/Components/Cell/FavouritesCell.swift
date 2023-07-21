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
    
    private let saloonImage = UIImageView()

    private let saloonName: UILabel = {
        let saloonName = UILabel()
        saloonName.font = .systemFont(ofSize: 12, weight: .bold)
        return saloonName
    }()
    
    private let favouritesStarImage = UIImageView(image: AssetImage.star_icon)
    
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

    func configure(model: DetailModelDB) {
        saloonImage.image = UIImage(data: model.image)
        saloonName.text = model.saloon_name
        ratingLabel.text = "\(CGFloat(data: model.rating))"
    }
}

extension FavouritesCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, saloonName,
                     favouritesStarImage, ratingLabel])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(101)
        }
        
        saloonName.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(3)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(110)
            make.bottom.equalTo(self).inset(10)
        }
        
        favouritesStarImage.snp.makeConstraints { make in
            make.centerY.equalTo(saloonName.snp.centerY)
            make.right.equalTo(self).inset(10)
        }

        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(saloonName)
            make.right.equalTo(self).inset(20)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }
}
