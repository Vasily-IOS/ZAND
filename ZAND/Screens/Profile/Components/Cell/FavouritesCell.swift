//
//  FavouritesCell.swift
//  ZAND
//
//  Created by Василий on 03.05.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class FavouritesCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        saloonImage.contentMode = .scaleAspectFill
        saloonImage.clipsToBounds = true
        saloonImage.image = AssetImage.noFoto_icon.image
        return saloonImage
    }()

    private let saloonNameLabel: UILabel = {
        let saloonName = UILabel()
        saloonName.font = .systemFont(ofSize: 12, weight: .bold)
        saloonName.numberOfLines = 0
        return saloonName
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setSelf()
        setViews()
    }

    func configure(model: Saloon) {
        saloonNameLabel.text = model.saloonCodable.title
        saloonImage.kf.setImage(with: URL(string: model.saloonCodable.company_photos.first ?? ""))
    }
}

extension FavouritesCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, saloonNameLabel])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(101)
        }
        
        saloonNameLabel.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(3)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).inset(10)
            make.bottom.equalTo(self).inset(10)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }
}
