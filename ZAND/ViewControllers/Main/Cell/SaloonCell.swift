//
//  SaloonCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonCell: BaseCollectionCell {
    
    // MARK:  - Closures
    
    var viewOnMapHandler: ((String) -> ())?
    var favouritesHandler: ((IndexPath) -> ())?
    
    // MARK: - Properties
    
    var coordinates: String?
    var indexPath: IndexPath?
    
    var isInFavourite: Bool = false {
        didSet {
            let image = isInFavourite ? ImageAsset.fillHeart_icon : ImageAsset.heart
            favouritesButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - UI
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        return saloonImage
    }()
    
    private let saloonDescriptionLabel = UILabel(.systemFont(ofSize: 20))
    private let categoryLabel = UILabel(.systemFont(ofSize: 12), .textGray)
    private let adressLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var leftStackView = UIStackView(alignment: .top,
                                                 arrangedSubviews: [
                                                    saloonDescriptionLabel,
                                                    categoryLabel,
                                                    adressLabel
                                                 ],
                                                 axis: .vertical,
                                                 distribution: .equalSpacing,
                                                 spacing: 4)
    
    private let favouritesButton: UIButton = {
        let favouritesButton = UIButton()
        favouritesButton.setImage(ImageAsset.heart, for: .normal)
        return favouritesButton
    }()
    
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)
    
    private let starImage: UIImageView = {
        let starImage = UIImageView()
        starImage.image = ImageAsset.star_icon
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
        setTarget()
    }
    
    // MARK: - Configuration
    
    func configure(model: SaloonMockModel, indexPath: IndexPath) {
        self.saloonImage.image = model.image
        self.saloonDescriptionLabel.text = model.name
        self.categoryLabel.text = model.category.name
        self.adressLabel.text = model.adress
        self.ratingLabel.text = "\(model.rating)"
        self.coordinates = model.coordinates
        self.indexPath = indexPath
    }
    
    // MARK: - Action
    
    @objc
    private func viewOnMapAction() {
        if let coordinates = coordinates {
            viewOnMapHandler?(coordinates)
        }
    }
    
    @objc
    private func favouritesAction() {
        if let indexPath = indexPath {
            favouritesHandler?(indexPath)
        }
    }
}

extension SaloonCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, leftStackView, favouritesButton,
                     viewOnMapButton, starImage, ratingLabel])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(214)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(12)
            make.left.equalTo(self).offset(10)
        }

        favouritesButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        viewOnMapButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.height.equalTo(15)
            make.centerY.equalTo(leftStackView.subviews[2])
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
    
    private func setTarget() {
        viewOnMapButton.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouritesAction), for: .touchUpInside)
    }
}
