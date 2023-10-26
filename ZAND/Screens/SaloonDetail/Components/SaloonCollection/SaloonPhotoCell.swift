//
//  SaloonPhotoCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class SaloonPhotoCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        saloonImage.contentMode = .scaleAspectFill
        saloonImage.clipsToBounds = true
//        saloonImage.image = AssetImage.noFoto_icon
        return saloonImage
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }
    
    // MARK: - Configure

    func configure(image: String) {
        if let url = URL(string: image) {
            saloonImage.kf.setImage(with: url)
        }
    }

    func configure(image: Data?) {
        saloonImage.image = AssetImage.noFoto_icon
    }
}

extension SaloonPhotoCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(saloonImage)

        saloonImage.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
}
