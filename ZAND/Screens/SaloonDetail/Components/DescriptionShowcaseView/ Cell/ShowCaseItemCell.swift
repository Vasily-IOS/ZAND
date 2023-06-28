//
//  ShowCaseItemCell.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

final class ShowCaseItemCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let showCaseImage: UIImageView = {
        let showCaseImage = UIImageView(image: UIImage(named: "1"))
        showCaseImage.clipsToBounds = true
        showCaseImage.layer.cornerRadius = 15.0
        return showCaseImage
    }()
    
    private let itemLabel = UILabel(.systemFont(ofSize: 12), nil, "Мужская стрижка")
    
    private let priceLabel = UILabel(.systemFont(ofSize: 12), nil, "От 400 руб.")
    
    private lazy var stackView = UIStackView(alignment: .leading,
                                             arrangedSubviews: [
                                                showCaseImage,
                                                itemLabel,
                                                priceLabel
                                             ],
                                             axis: .vertical,
                                             distribution: .equalSpacing,
                                             spacing: 10)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        setViews()
    }
}

extension ShowCaseItemCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
        }

        showCaseImage.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    private func setSelf() {
        clipsToBounds = true
        backgroundColor = .mainGray
    }
}
