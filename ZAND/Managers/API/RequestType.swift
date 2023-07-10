//
//  Network.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation
import Moya

enum RequestType {
    case post
}

extension RequestType: TargetType {

    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .post:
            return "/posts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .post:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .post:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

struct Post: Codable {
    let userId: Int
    let title: String
}
