//
//  SaloonDetailView.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

protocol SaloonDetailDelegate: AnyObject {
    func openMap()
    func openBooking()
}

final class SaloonDetailView: BaseUIView {

    // MARK: - Properties

    weak var delegate: SaloonDetailDelegate?
    
    private lazy var saloonPhotoCollection = SaloonPhotoCollection()
    private lazy var addressView = AddressView()
    private lazy var descriptionShowcaseView = DescriptionShowcaseView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .mainGray
        return scrollView
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        viewAction()
    }

    func configure(model: SaloonMockModel) {
        saloonPhotoCollection.configure(model: model)
        addressView.configure(model: model)
        descriptionShowcaseView.configure(model: model)
    }

    // MARK: - Action

    private func viewAction() {

        saloonPhotoCollection.openBookingHandler = { [weak self] in
            self?.delegate?.openBooking()
        }
        
        addressView.mapHandler = { [weak self] in
            self?.delegate?.openMap()
        }
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
}
