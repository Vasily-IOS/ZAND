//
//  Network.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation
import Moya

enum RequestType {
    // Данные о салонах, подключивших приложение 👍
    case salons

    // получить все категории услуг 👍
    case categories(Int)

    // Получить список услуг, доступных для бронирования 👍
    case bookServices(company_id: Int)

    // Получить список сотрудников доступных для бронирования 👍
    case bookStaff(company_id: Int, service_id: [Int])

    // Получить список дат, доступных для бронирования 👍
    case bookDates(
        company_id: Int,
        service_ids: [String],
        staff_id: Int,
        date: String,
        date_from: String,
        date_to: String
    )

    // Получить список сеансов, доступных для бронирования 👍
    case bookTimes(company_id: Int, staff_id: Int, date: String, service_id: Int)




    // получить список сотрудников
    case staff(company_id: Int)

    // получить конкретного сотрудника
    case staffByID(company_id: Int, staff_id: Int) // получить конкретного сотрудника



    // MARK: - deprecated requests

    case freeTime(company_id: Int, staff_id: Int, date: String)
    case services(company_id: Int) // получить услуги по данной категории
    case employeeSchedule(company_id: Int, staff_id: Int, start_date: Int, end_date: Int) // получить расписание сотрудника

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
        case .bookServices(let company_id):
            return "/api/v1/book_services/\(company_id)"
        case .bookStaff(let company_id, _):
            return "/api/v1/book_staff/\(company_id)"
        case .bookDates(let company_id,_, _, _, _, _):
            return "/api/v1/book_dates/\(company_id)"
        case .bookTimes(let company_id, let staff_id, let date, _):
            return "/api/v1/book_times/\(company_id)/\(staff_id)/\(date)"


            // MARK: - deprecated
        case .staff(let company_id):
            return "/api/v1/company/\(company_id)/staff/"
        case .staffByID(let company_id, let staff_id):
            return "/api/v1/company/\(company_id)/staff/\(staff_id)"
        case .services(let company_id):
            return "/api/v1/company/\(company_id)/services/"
        case .employeeSchedule(let company_id, let staff_id, let start_date, let end_date):
            return "/api/v1/schedule/\(company_id)/\(staff_id)/\(start_date)/\(end_date)"
        case .freeTime(let company_id, let staff_id, let date):
            return "/api/v1/timetable/seances/\(company_id)/\(staff_id)/\(date)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .salons, .categories, .bookServices, .bookStaff, .staff,
                .staffByID, .bookDates, .bookTimes:
            return .get

        // MARK: - deprecated

        case .employeeSchedule, .freeTime, .services:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .salons, .categories, .bookServices, .staff, .staffByID, .bookTimes:
            return .requestPlain
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
        case .bookDates(_, let service_ids, let staff_id, _, _, _):
            let parameters: [String: Any] = ["staff_id": staff_id,
                                             "service_ids": service_ids]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )

            // MARK: - deprecated

        case .employeeSchedule, .freeTime, .services:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .salons, .bookServices, .bookDates, .bookStaff:
            return ["Authorization": "Bearer \(bearerToken)",
                    "Accept": "application/vnd.api.v2+json"]
        case .categories, .staff, .staffByID, .bookTimes:
            return ["Content-type": "application/json",
                    "Accept": "application/vnd.api.v2+json",
                    "Authorization": "Bearer \(bearerToken), User \(userToken)"]

            // MARK: - deprecated

        case .employeeSchedule, .freeTime, .services:
            return ["Content-type": "application/json",
                    "Accept": "application/vnd.api.v2+json",
                    "Authorization": "Bearer \(bearerToken), User \(userToken)"]
        }
    }
}
