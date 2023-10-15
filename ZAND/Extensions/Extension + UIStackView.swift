//
//  UIStackViewExtension.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
    
    public convenience init(
        alignment: UIStackView.Alignment = .fill,
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
    func addArrangedSubview(_ v:UIView, withMargin m: UIEdgeInsets) {
        let containerForMargin = UIView()
        containerForMargin.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: containerForMargin.topAnchor, constant:m.top ),
            v.bottomAnchor.constraint(equalTo: containerForMargin.bottomAnchor, constant: m.bottom ),
            v.leftAnchor.constraint(equalTo: containerForMargin.leftAnchor, constant: m.left),
            v.rightAnchor.constraint(equalTo: containerForMargin.rightAnchor, constant: m.right)
        ])
        addArrangedSubview(containerForMargin)
    }
}
