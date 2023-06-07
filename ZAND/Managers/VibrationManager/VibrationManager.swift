//
//  VibrationManager.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit

final class VibrationManager {
    
    static let shared = VibrationManager()
    
    private init() {}
    
    func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedBackGenerator = UISelectionFeedbackGenerator()
            selectionFeedBackGenerator.prepare()
            selectionFeedBackGenerator.selectionChanged()
        }
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
}
