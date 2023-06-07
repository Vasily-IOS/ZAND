//
//  BackView.swift
//  ZAND
//
//  Created by Василий on 05.06.2023.
//

import UIKit
import SnapKit

final class BackView: BaseUIView {
    
    // MARK: - Closures
    
    var didTapHandler: (() -> ())?
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(ImageAsset.back_icon, for: .normal)
        backButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        return backButton
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
    }
    
    // MARK: - Action
    
    @objc
    private func didTapAction() {
        didTapHandler?()
    }
}

extension BackView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .clear
    }
}
