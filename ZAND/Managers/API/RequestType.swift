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
    case categories(Int) // категория услуг/получить список категории услуг
    case services(company_id: Int, category_id: Int) // получить сервисов по данной категории
    case staff(company_id: Int) // получить список сотрудников
    case staffByID(company_id: Int, staff_id: Int) // получить конкретного сотрудника
    case employeeSchedule(company_id: Int, staff_id: Int, start_date: Int, end_date: Int) // получить расписание сотрудника
    case freeTime(company_id: Int, staff_id: Int, date: String) // cвободное время сотрудника по определенному дню

//    case createRecord // https://api.yclients.com/api/v1/records/{company_id}
//    создание записи POST

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
        case .categories(let company_id):
            return "/api/v1/company/\(company_id)/service_categories/"
        case .services(let company_id, _):
            return "/api/v1/company/\(company_id)/services/"
        case .staff(let company_id):
            return "/api/v1/company/\(company_id)/staff/"
        case .staffByID(let company_id, let staff_id):
            return "/api/v1/company/\(company_id)/staff/\(staff_id)"
        case .employeeSchedule(let company_id, let staff_id, let start_date, let end_date):
            return "/api/v1/schedule/\(company_id)/\(staff_id)/\(start_date)/\(end_date)"
        case .freeTime(let company_id, let staff_id, let date):
            return "/api/v1/timetable/seances/\(company_id)/\(staff_id)/\(date)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .salons, .categories, .services, .staff,
                .staffByID, .employeeSchedule, .freeTime:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .salons, .categories, .staff, .staffByID, .employeeSchedule, .freeTime:
            return .requestPlain
        case .services(_, let category_id):
            if category_id == 0 {
                return .requestPlain
            } else {
                let parameters: [String: Any] = ["category_id":"\(category_id)"]
                return .requestParameters(
                    parameters: parameters,
                    encoding: URLEncoding.default
                )
            }
        }
    }

    var headers: [String : String]? {
        switch self {
        case .salons:
            return ["Authorization": "Bearer \(bearerToken)",
                    "Accept": "application/vnd.api.v2+json"]
        case .categories, .services, .staff, .staffByID, .employeeSchedule, .freeTime:
            return ["Content-type": "application/json",
                    "Accept": "application/vnd.api.v2+json",
                    "Authorization": "Bearer \(bearerToken), User \(userToken)"]
        }
    }
}
