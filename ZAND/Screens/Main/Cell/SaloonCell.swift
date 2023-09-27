//
//  SaloonCell.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit
import Lottie
import Kingfisher

final class SaloonCell: BaseCollectionCell {
    
    // MARK:  - Closures
    
    var mapHandler: ((Int) -> ())?

    var favouritesHandler: ((Int, IndexPath) -> ())?
    
    // MARK: - Properties

    var id: Int?

    var indexPath: IndexPath?
    
    var isInFavourite: Bool = false {
        didSet {
            let image = isInFavourite ? AssetImage.fillHeart_icon : AssetImage.heart
            favouritesButton.setImage(image, for: .normal)

            if isInFavourite {
                animationView.isHidden = false
                favouritesButton.isUserInteractionEnabled = false
                animationView.play()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.favouritesButton.isUserInteractionEnabled = true
                    self.animationView.isHidden = true
                }
            }
        }
    }

    // MARK: - UI
    
    private let saloonImage: UIImageView = {
        let saloonImage = UIImageView()
        saloonImage.contentMode = .scaleAspectFill
        saloonImage.clipsToBounds = true
        return saloonImage
    }()
    
    private let saloonDescriptionLabel = UILabel(.systemFont(ofSize: 20))

    private let categoryLabel: UILabel = {
        let categoryLabel = UILabel(.systemFont(ofSize: 12), .textGray)
        categoryLabel.numberOfLines = 0
        return categoryLabel
    }()

    private let adressLabel: UILabel = {
        let adressLabel = UILabel(.systemFont(ofSize: 12))
        adressLabel.numberOfLines = 0
        return adressLabel
    }()
    
    private lazy var leftStackView = UIStackView(
        alignment: .top,
        arrangedSubviews: [
            saloonDescriptionLabel,
            categoryLabel,
            adressLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 4
    )
    
    private let favouritesButton = UIButton()
    
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)

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

    func configure(model: Saloon, indexPath: IndexPath) {
        self.saloonDescriptionLabel.text = model.title
        self.categoryLabel.text = model.short_descr
        self.adressLabel.text = model.address
        self.id = model.id
        self.indexPath = indexPath

        if model.photos.isEmpty && model.company_photos.isEmpty {
            saloonImage.image = AssetImage.noFoto_icon
        } else {
            if let url = URL(string: model.company_photos.first ?? "") {
                saloonImage.kf.setImage(with: url)
            }
        }
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
                     viewOnMapButton, animationView])
        
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
            make.right.equalTo(contentView.snp.right).inset(16)
            make.left.equalTo(leftStackView.snp.right).offset(16)
            make.height.equalTo(15)
            make.width.equalTo(125)
            make.centerY.equalTo(leftStackView.subviews[2])
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
        viewOnMapButton.addTarget(
            self,
            action: #selector(viewOnMapAction),
            for: .touchUpInside
        )
        favouritesButton.addTarget(
            self,
            action: #selector(favouritesAction),
            for: .touchUpInside
        )
    }
}
