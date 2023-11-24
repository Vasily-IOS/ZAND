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
        return successAnimation
    }()

    private let failureAnimation: LottieAnimationView = {
        var failureAnimation = LottieAnimationView(name: Config.animation_entryNoConfirmed)
        failureAnimation.play()
        return failureAnimation
    }()

    private let finalLabel: UILabel = {
        let finalLabel = UILabel()
        finalLabel.font = .systemFont(ofSize: 16, weight: .bold)
        return finalLabel
    }()

    private lazy var stackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [
            failureAnimation,
            finalLabel
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 40
    )

    // MARK: - Instance methods

    func configure(isSuccess: Bool) {
        if isSuccess {
            finalLabel.text = AssetString.finalText.rawValue
            setupSuccessSubviews()
        } else {
            finalLabel.text = AssetString.errorText.rawValue
            setupFailureSubviews()
        }
        VibrationManager.shared.vibrate(for: .success)
    }

    private func setupSuccessSubviews() {
        addSubviews([successAnimation, finalLabel])

        successAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        finalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(successAnimation).offset(180)
            make.centerX.equalToSuperview()
        }
    }

    private func setupFailureSubviews() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
