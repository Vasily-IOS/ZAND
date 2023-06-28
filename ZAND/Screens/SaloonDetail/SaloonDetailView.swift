//
//  SaloonDetailView.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

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
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
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
        scrollView.addSubviews([saloonPhotoCollection,
                                addressView, descriptionShowcaseView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        saloonPhotoCollection.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.left.right.equalTo(self)
        }
        
        addressView.snp.makeConstraints { make in
            make.top.equalTo(saloonPhotoCollection.snp.bottom).offset(0)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        descriptionShowcaseView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    private func setBackgroundColor() {
        scrollView.backgroundColor = .mainGray
    }
}