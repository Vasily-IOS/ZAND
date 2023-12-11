//
//  UserAnnotation.swift
//  ZAND
//
//  Created by Василий on 12.11.2023.
//

import MapKit

final class UserAnnotation: MKAnnotationView {

    // MARK: - Properties

    private let mainSize: CGFloat = 30.0

    // MARK: - Initializers

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        // Настройка вида аннотации
        self.frame = CGRect(x: 0, y: 0, width: mainSize, height: mainSize)
        self.backgroundColor = .blue
        self.layer.cornerRadius = mainSize / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
