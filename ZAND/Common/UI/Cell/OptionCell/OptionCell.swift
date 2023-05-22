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
    
    override var isSelected: Bool {
        didSet {
            optionView.isSelected = isSelected
        }
    }

    // MARK: - Properties
    
    private let optionView = OptionView()
    private let descriptionLabel = UILabel(.systemFont(ofSize: 14), .black)
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
    }
    
    // MARK: - Configure
    
    func configure(model: OptionsModel, state: State) {
        descriptionLabel.text = model.name
        optionView.configure(image: model.image)
        setBackgroundColor(color: state.backgroundColor)
    }
}

extension OptionCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([optionView, descriptionLabel])
        
        self.snp.makeConstraints { make in
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
