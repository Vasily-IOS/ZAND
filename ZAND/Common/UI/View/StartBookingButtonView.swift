//
//  StartBookingButtonView.swift
//  ZAND
//
//  Created by Василий on 19.09.2023.
//

import UIKit
import SnapKit

final class StartBookingButtonView: BaseUIView {

    // MARK: - Nested types

    enum State {
        case service
        case sprecialist

        var text: String {
            switch self {
            case .service:
                return AssetString.selectService.rawValue
            case .sprecialist:
                return AssetString.selectStaff.rawValue
            }
        }

        var image: UIImage {
            switch self {
            case .service:
                return AssetImage.start_booking_service_icon.image
            case .sprecialist:
                return AssetImage.start_booking_specialist_icon.image
            }
        }
    }

    // MARK: - Properties

    var tapHandler: (() -> Void)?

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .black.withAlphaComponent(0.75)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()

    private let typeImage: UIImageView = {
        let typeImage = UIImageView()
        typeImage.contentMode = .scaleAspectFit
        return typeImage
    }()

    // MARK: - Initializers

    init(state: State) {
        super.init(frame: .zero)

        titleLabel.text = state.text
        typeImage.image = state.image

        setRecognizer()
    }

    // MARK: - Instance methods

    @objc
    private func didTapAction() {
        tapHandler?()
    }

    override func setup() {
        super.setup()

        layer.cornerRadius = 15.0
        createDefaultShadow(for: self)

        addSubviews([titleLabel, typeImage])

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(130)
        }

        typeImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }

    private func setRecognizer() {
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapAction))
        )
    }
}
