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
    
    func disableAutoresizeFramesFor(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func createDefaultShadow(for myView: UIView) {
        myView.layer.shadowColor = UIColor.darkGray.cgColor
        myView.layer.shadowOffset = CGSize(width: 0, height: 3)
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 4
        
        myView.clipsToBounds = false
        myView.layer.masksToBounds = false
    }
    
    func rotateImageView(isSelected: Bool, image: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999 )
            let down = CGAffineTransform(rotationAngle: 0)
            image.transform = isSelected ? upsideDown : down
        }
    }
    
    func rotate( _ isRotate: Bool) {
        let value: Double = isRotate ? Double.pi * -0.999 : 0
        self.transform = CGAffineTransform(rotationAngle: CGFloat(value))
    }
    
    func gesture(_ type: GestureType) -> GesturePublisher {
        GesturePublisher(view: self, gestureType: type)
    }
}
