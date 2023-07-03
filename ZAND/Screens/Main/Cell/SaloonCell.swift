//
//  SaloonCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit
import Lottie

final class SaloonCell: BaseCollectionCell {
    
    // MARK:  - Closures
    
    var mapHandler: ((Int) -> ())?

    var favouritesHandler: ((Int, IndexPath) -> ())?
    
    // MARK: - Properties

    var id: Int?

    var indexPath: IndexPath?
    
    var isInFavourite: Bool = false {
        didSet {
            let image = isInFavourite ? ImageAsset.fillHeart_icon : ImageAsset.heart
            favouritesButton.setImage(image, for: .normal)

            if isInFavourite {
                animationView.isHidden = false
                animationView.play()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animationView.isHidden = true
                }
            }
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

    private lazy var animationView: LottieAnimationView = {
        var animationView = LottieAnimationView(name: Config.animation_fav)
        animationView.isHidden = true
        return animationView
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
        self.saloonDescriptionLabel.text = model.saloon_name
        self.categoryLabel.text = model.category.name
        self.adressLabel.text = model.adress
        self.ratingLabel.text = "\(model.rating)"
        self.indexPath = indexPath
        self.id = model.id
    }
    
    // MARK: - Action
    
    @objc
    private func viewOnMapAction() {
        if let id = id {
            mapHandler?(id)
        }
    }
    
    @objc
    private func favouritesAction() {
        if let id = id, let indexPath = indexPath {
            favouritesHandler?(id, indexPath)
        }
    }
}

extension SaloonCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([saloonImage, leftStackView, favouritesButton,
                     viewOnMapButton, starImage, ratingLabel, animationView])
        
        saloonImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(214)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.top.equalTo(saloonImage.snp.bottom).offset(12)
            make.left.equalTo(self).offset(10)
        }

        favouritesButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(24)
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

        animationView.snp.makeConstraints { make in
            make.bottom.equalTo(favouritesButton)
            make.centerX.equalTo(favouritesButton)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func setTarget() {
        viewOnMapButton.addTarget(self,
                                  action: #selector(viewOnMapAction),
                                  for: .touchUpInside)
        favouritesButton.addTarget(self,
                                   action: #selector(favouritesAction),
                                   for: .touchUpInside)
    }
}
