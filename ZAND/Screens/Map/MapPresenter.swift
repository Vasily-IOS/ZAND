//
//  MapPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol MapPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> [SaloonMapModel]
    func getModel(by id: Int) -> SaloonMapModel?
}

protocol MapViewInput: AnyObject {
    func updateUI(model: [SaloonMapModel])
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    var saloons: [Saloon] = []

    private let provider: SaloonProvider

    // MARK: - Initializers

    init(view: MapViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        subscribeNotifications()
    }

    // MARK: - Instance methods

    @objc
    private func updateData() {
        updateUI()
    }

    @objc
    private func connectivityStatus(_ notification: Notification) {
        if let isConnected = notification.userInfo?["connectivityStatus"] as? Bool {
            if isConnected {
                updateUI()
            }
        }
    }

    func updateUI() {
        provider.fetchData { [weak self] saloons in
            self?.view?.updateUI(model: saloons)
        }
    }

    func getModel() -> [SaloonMapModel] {
        return saloons
    }

    func getModel(by id: Int) -> SaloonMapModel? {
        let model = saloons.first(where: { $0.id == id })
        return model == nil ? nil : model
    }

    // MARK: - Private

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateData),
            name: .updateData,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }
}
