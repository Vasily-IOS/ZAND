//
//  MapView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import MapKit

final class MapView: BaseUIView {
    
    // MARK: - Closures
    
    private let searchClosure = {
        AppRouter.shared.present(type: .search)
    }
    
    // MARK: - Properties
    
    private lazy var searchButton = SearchButton(handler: searchClosure)
    private let mapView = MKMapView()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
    }
}

extension MapView {
    
    private func setViews() {
        addSubviews([searchButton, mapView])
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.left.bottom.right.equalTo(self)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}
