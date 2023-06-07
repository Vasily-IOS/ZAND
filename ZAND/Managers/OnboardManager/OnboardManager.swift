//
//  OnboardingManager.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit

final class OnboardManager {
    
    static let shared = OnboardManager()
    
    private init() {}
    
    func isUserFirstLaunch() -> Bool {
        let isFirst = UserDefaults.standard.bool(forKey: StringsAsset.firstLaunch)
        return !isFirst
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: StringsAsset.firstLaunch)
    }
}
