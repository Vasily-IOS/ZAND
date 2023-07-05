//
//  SaloonPhotoCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonPhotoCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        saloonImage.contentMode = .scaleToFill
        return saloonImage
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }
    
    // MARK: - Configure
    
    func configure(image: UIImage) {
        saloonImage.image = image
    }

    func configure(image: Data) {
        saloonImage.image = UIImage(data: image)
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
