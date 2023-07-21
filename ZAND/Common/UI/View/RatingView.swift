//
//  RatingView.swift
//  ZAND
//
//  Created by Василий on 08.06.2023.
//

import UIKit
import SnapKit

final class RatingView: BaseUIView {
    
    // MARK: - Properties
    
    private lazy var starImage: UIImageView = {
        var starImage = UIImageView()
        starImage.image = AssetImage.star_icon
        return starImage
    }()
    
    private lazy var ratingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 16)
        return ratingLabel
    }()
    
    private lazy var ratingStackView = UIStackView(alignment: .center,
                                                   arrangedSubviews: [
                                                    starImage,
                                                    ratingLabel
                                                   ],
                                                   axis: .horizontal,
                                                   distribution: .equalSpacing,
                                                   spacing: 5)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
    }

    // MARK: - Configure
    
    func configure(rating: CGFloat) {
        ratingLabel.text = "\(rating)"
    }
}

extension RatingView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(ratingStackView)
        
        ratingStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}
