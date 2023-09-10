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
    case company // Получить список компаний (не уверен, что нужен)
    case userToken // метод, который возвращает токен для просмотра записей пользователя
    case appointments // Записи пользователя

    var applicationID: Int {
        return 1825
    }

    var bearerToken: String {
        return "fbast32fa6hp2j6wz8hg"
    }

    var recordID: Int {
        return 1
    }

    var recordHash: Int {
        return 1
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
        case .company:
            return "api/v1/companies"
        case .appointments:
            return "/api/v1/user/records/\(recordID)\(recordHash)"
        case .userToken:
            return "/api/v1/user/auth"
        }
    }

    var method: Moya.Method {
        switch self {
        case .salons, .company, .appointments, .userToken:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .salons, .company, .appointments, .userToken:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Authorization": "Bearer \(bearerToken)",
                "Content-type": "multipart/form-data",
                "Accept": "application/vnd.api.v2+json"]
    }
}
