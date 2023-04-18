//
//  VCFactory.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class VCFactory: DefaultVCFactory {
    
    func getViewController(for type: VCType) -> UIViewController {
        switch type {
        case .tabBar:
            let vc = TabBarController()
            return vc
        case .search:
            let view = SearchView()
            let vc = SearchViewController(contentView: view)
            return vc
        }
    }
}
