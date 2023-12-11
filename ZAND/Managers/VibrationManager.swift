//
//  VibrationManager.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit

final class VibrationManager {

    // MARK: - Properties
    
    static let shared = VibrationManager()

    // MARK: - Initializer
    
    private init() {}

    // MARK: - Instance methods
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
}
