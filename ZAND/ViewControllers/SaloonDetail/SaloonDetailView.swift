//
//  SaloonDetailView.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit

final class SaloonDetailView: BaseUIView {
    
    // MARK: - Model
    
    private let salonMockModel: SaloonMockModel
    
    // MARK: - UI
    
    private lazy var saloonPhotoCollection = SaloonPhotoCollection(model: salonMockModel)
    private lazy var addressView = AddressView(model: salonMockModel)
    private lazy var descriptionShowcaseView = DescriptionShowcaseView(model: salonMockModel)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Initializers
    
    init(model: SaloonMockModel) {
        self.salonMockModel = model
        super.init(frame: .zero)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
    }
}

extension SaloonDetailView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        disableAutoresizeFramesFor([scrollView, stackView, addressView])
        
        stackView.addArrangedSubview(saloonPhotoCollection)
        stackView.addArrangedSubview(addressView)
        stackView.addArrangedSubview(descriptionShowcaseView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setBackgroundColor() {
        scrollView.backgroundColor = .mainGray
    }
}
