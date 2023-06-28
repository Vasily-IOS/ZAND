//
//  ProfileCell.swift
//  ZAND
//
//  Created by Василий on 03.05.2023.
//

import UIKit
import SnapKit

final class ProfileCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let profileOptionImage: UIImageView = {
        let profileOptionImage = UIImageView()
        return profileOptionImage
    }()
    
    private let profileOptionLabel: UILabel = {
        let profileOptionLabel = UILabel()
        profileOptionLabel.font = .systemFont(ofSize: 16)
        return profileOptionLabel
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
    }
    
    func configure(model: ProfileMenuModel) {
        profileOptionImage.image = model.image
        profileOptionLabel.text = model.description
    }
}

extension ProfileCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        layer.cornerRadius = 15

        addSubviews([profileOptionImage, profileOptionLabel])
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        profileOptionImage.snp.makeConstraints { make in
            make.left.equalTo(self).offset(12)
            make.centerY.equalTo(self)
        }
        
        profileOptionLabel.snp.makeConstraints { make in
            make.left.equalTo(profileOptionImage.snp.right).offset(12)
            make.centerY.equalTo(self)
        }
    }
}
