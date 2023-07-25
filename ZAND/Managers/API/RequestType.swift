//
//  Network.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation
import Moya

enum RequestType {
    case saloons

    var applicationID: Int {
        return 1
    }

    var bearerToken: String {
        return "tokenExample"
    }
}

extension RequestType: TargetType {

    var baseURL: URL {
        return URL(string: URLS.baseURL)!
    }

    var path: String {
        switch self {
        case .saloons:
            return "/marketplace/application/\(applicationID)/salons"
        }
    }

    var method: Moya.Method {
        switch self {
        case .saloons:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .saloons:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

//https://api.yclients.com/marketplace/application/{application_id}/salons
