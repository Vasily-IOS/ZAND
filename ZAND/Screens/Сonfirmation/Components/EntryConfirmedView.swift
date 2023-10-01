//
//  EntryConfirmedView.swift
//  ZAND
//
//  Created by Василий on 29.09.2023.
//

import UIKit
import Lottie
import SnapKit

final class EntryConfirmedView: BaseUIView {

    // MARK: - Properties

    private lazy var successAnimation: LottieAnimationView = {
        var successAnimation = LottieAnimationView(name: Config.animation_entryConfimed)
        successAnimation.play()
//        successAnimation.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return successAnimation
    }()

    private let failureAnimation: LottieAnimationView = {
        var failureAnimation = LottieAnimationView(name: Config.animation_entryNoConfirmed)
        failureAnimation.play()
        return failureAnimation
    }()

    private let finalLabel: UILabel = {
        let finalLabel = UILabel()
        finalLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return finalLabel
    }()

    private lazy var stackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [
            successAnimation,
            failureAnimation,
            finalLabel
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 40
    )

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setupSubviews()
    }

    func configure(isSuccess: Bool) {
        if isSuccess {
//            finalLabel.text = AssetString.finalText
            finalLabel.text = ""
            stackView.subviews[1].isHidden = true
        } else {
            finalLabel.text = AssetString.errorText
            stackView.subviews[0].isHidden = true
        }
    }

    private func setupSubviews() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
