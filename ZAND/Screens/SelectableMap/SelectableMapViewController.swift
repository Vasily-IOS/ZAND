//
//  SelectableMapViewController.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit

final class SelectableViewController: BaseViewController<SelectableMapView> {
    
    // MARK: - Properties

    var presenter: SelectablePresenterImpl?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()

        showNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.getModel()
    }
    
    deinit {
        print("MapVC died")
    }
}

extension SelectableViewController: SelectablePresenter {

    // MARK: - SelectablePresenter methods

    func updateUI(model: CommonModel) {
        contentView.addPinsOnMap(model: model)
    }
}

extension SelectableViewController: ShowNavigationBar {}
