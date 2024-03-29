//
//  UIView.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func createDefaultShadow(for myView: UIView) {
        myView.layer.shadowColor = UIColor.darkGray.cgColor
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 4
        
        myView.clipsToBounds = false
        myView.layer.masksToBounds = false
    }
    
    func rotate( _ isRotate: Bool) {
        let value: Double = isRotate ? Double.pi * -0.999 : 0
        self.transform = CGAffineTransform(rotationAngle: CGFloat(value))
    }
}
