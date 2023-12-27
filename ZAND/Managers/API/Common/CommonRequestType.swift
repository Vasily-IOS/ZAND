//
//  Network.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation
import Moya

enum CommonRequestType {
    case salons // Данные о салонах, подключивших приложение
    case categories(Int) // получить все категории услуг
    case bookServices(company_id: Int, staff_id: Int = 0) // Получить список услуг, доступных для бронирования
    case bookStaff(company_id: Int, service_id: [Int]) // Получить список сотрудников доступных для бронирования
    case bookDates(_ model: FetchBookDateModel) // Получить список дат, доступных для бронирования
    case bookTimes(company_id: Int, staff_id: Int, date: String, service_id: Int) // Получить список сеансов, доступных для бронирования
    case createRecord(company_id: Int, model: ConfirmationModel) // Создать запись на сеанс
    case getRecord(company_id: Int, record_id: Int) // Получить запись

    // MARK: -

    var applicationID: Int {
        return AppID.id
    }

    var bearerToken: String {
        return "fbast32fa6hp2j6wz8hg"
    }

    var userToken: String {
        return "983196026753a4a61b7a6c638cc7dea7"
    }
}

extension CommonRequestType: TargetType {

    var baseURL: URL {
        return URL(string: AssetURL.yclientsURL.rawValue)!
    }

    var path: String {
        switch self {
        case .salons:
            return "/marketplace/application/\(applicationID)/salons"
        case .categories(let company_id):
            return "/api/v1/company/\(company_id)/service_categories/"
        case .bookServices(let company_id, _):
            return "/api/v1/book_services/\(company_id)"
        case .bookStaff(let company_id, _):
            return "/api/v1/book_staff/\(company_id)"
        case .bookDates(let model):
            return "/api/v1/book_dates/\(model.company_id)"
        case .bookTimes(let company_id, let staff_id, let date, _):
            return "/api/v1/book_times/\(company_id)/\(staff_id)/\(date)"
        case .createRecord(let company_id, _):
            return "/api/v1/book_record/\(company_id)"
        case .getRecord(let company_id, let record_id):
            return "/api/v1/record/\(company_id)/\(record_id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .salons, .categories, .bookServices, .bookStaff,
             .bookDates, .bookTimes, .getRecord:
            return .get
        case .createRecord:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .salons:
            let parameters: [String: Any] = ["count": 1000]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .categories, .bookTimes, .getRecord:
            return .requestPlain
        case .bookServices(_ , let staff_id):
            if staff_id == 0 {
                return .requestPlain
            }  else {
                let parameters: [String: Any] = ["staff_id": staff_id]
                return .requestParameters(
                    parameters: parameters,
                    encoding: URLEncoding.queryString
                )
            }
        case .bookStaff(_, let service_id):
            if service_id.isEmpty {
                return .requestPlain
            } else {
                let parameters: [String: Any] = ["service_ids": service_id]
                return .requestParameters(
                    parameters: parameters,
                    encoding: URLEncoding.queryString
                )
            }
        case .bookDates(let model):
            let parameters: [String: Any] = [
                "staff_id": model.staff_id,
                "service_ids": model.service_ids
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .createRecord(_, let model):
            return .requestJSONEncodable(model)
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json",
                "Accept": "application/vnd.api.v2+json",
                "Authorization": "Bearer \(bearerToken), User \(userToken)"]
    }
}
