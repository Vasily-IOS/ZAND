//
//  Network.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation
import Moya

enum RequestType {
    case salons // Данные о салонах, подключивших приложение
    case serviceCategory(Int) // категория услуг/получить список категории услуг
    case staff(Int) // получить список сотрудников/конкретного сотрудника

//    case allSaloonServices // https://api.yclients.com/api/v1/company/{company_id}/services/{service_id}
    // список всех услуг сети (Вкладка Услуги)

    var applicationID: Int {
        return 1825
    }

    var bearerToken: String {
        return "fbast32fa6hp2j6wz8hg"
    }

    var userToken: String {
        return "983196026753a4a61b7a6c638cc7dea7"
    }
}

extension RequestType: TargetType {

    var baseURL: URL {
        return URL(string: URLS.baseURL)!
    }

    var path: String {
        switch self {
        case .salons:
            return "/marketplace/application/\(applicationID)/salons"
        case .serviceCategory(let company_id):
            return "/api/v1/company/\(company_id)/service_categories/"
        case .staff(let company_id):
            return "/api/v1/company/\(company_id)/staff/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .salons, .serviceCategory, .staff:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .salons, .serviceCategory, .staff:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .salons:
            return ["Authorization": "Bearer \(bearerToken)",
                    "Accept": "application/vnd.api.v2+json"]
        case .serviceCategory, .staff:
            return ["Content-type": "application/json",
                    "Accept": "application/vnd.api.v2+json",
                    "Authorization": "Bearer \(bearerToken), User \(userToken)"]
        }
    }
}
