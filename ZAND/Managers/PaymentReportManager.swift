//
//  PaymentReportManager.swift
//  ZAND
//
//  Created by Василий on 29.01.2024.
//

import Foundation
import YandexMobileMetrica

class PaymentReportManager {

    // MARK: - Properties

    private let paymentReportKey = "paymentReportKey"

    static let shared = PaymentReportManager()

    var storageID: [Int] = [] {
        didSet {
            save(model: storageID, key: paymentReportKey)
        }
    }

    // MARK: - Initializers

    private init() {
        self.storageID = loadStorageID()
    }

    // MARK: - Instance methods

    func saveAndSendReport(model: GetRecord) {
        if !contains(modelID: model.id) {
            storageID.append(model.id)

            let parameters: [AnyHashable: Any] = [
                "id": "\(model.id)", // id записи
                "title": "\(model.services.first?.title ?? "")",
                "cost": "\(model.services.first?.cost ?? 0.0)",
                "first_cost": "\(model.services.first?.first_cost ?? 0.0)",
            ]

            YMMYandexMetrica.reportEvent("service_provided", parameters: parameters, onFailure: nil)
        }
    }

    // MARK: - Private

    private func save(model: [Int], key: String) {
        UserDefaults.standard.set(model, forKey: paymentReportKey)
    }

    private func loadStorageID() -> [Int] {
        return UserDefaults.standard.array(forKey: paymentReportKey) as? [Int] ?? []
    }

    private func contains(modelID: Int) -> Bool {
        return storageID.contains(where: { $0 == modelID })
    }
}
