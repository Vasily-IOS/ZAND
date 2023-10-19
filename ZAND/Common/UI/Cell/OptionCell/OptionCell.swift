//
//  OptionCell.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class OptionCell: BaseCollectionCell {
    
    // MARK: - Nested types
    
    enum State {
        case onMain
        case onFilter
        
        var backgroundColor: UIColor {
            switch self {
            case .onMain:
                return .mainGray
            case .onFilter:
                return .white
            }
        }
    }

    // MARK: - Properties

    var isTapped: Bool = false {
        didSet {
            optionView.isSelected = isTapped
        }
    }
    
    private let optionView = OptionView()
    
    private let descriptionLabel = UILabel(.systemFont(ofSize: 14), .black)
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }

    func configure(model: CommonFilterProtocol, state: State) {
        if let model = model as? OptionsModel {
            descriptionLabel.text = model.name
            optionView.configure(image: model.image)
            setBackgroundColor(color: state.backgroundColor)
        }
    }
}

extension OptionCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([optionView, descriptionLabel])
        
        snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        
        optionView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(optionView.snp.bottom).offset(8)
            make.centerX.equalTo(optionView)
        }
    }
    
    private func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
}
