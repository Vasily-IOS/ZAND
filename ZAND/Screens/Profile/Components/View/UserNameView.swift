//
//  UserNameView.swift
//  ZAND
//
//  Created by Василий on 27.04.2023.
//

import UIKit
import SnapKit

final class UserNameView: BaseUIView {
    
    // MARK: - Properties
    
    private let userAccountLabel = UILabel(.systemFont(ofSize: 14),
                                           .black,
                                           StringsAsset.user_name)

    private let nameLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                    .black,
                                    "Петрова Анфиса")

    private let emailLabel = UILabel(.systemFont(ofSize: 12), .textGray, "test@gmail.com")
    
    private lazy var userNameStackView = UIStackView(arrangedSubviews:
                                                        [userAccountLabel,
                                                         nameLabel,
                                                         emailLabel],
                                                     axis: .vertical,
                                                     spacing: 10)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
    }
}

extension UserNameView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubview(userNameStackView)
        userNameStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
