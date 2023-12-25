//
//  AuthRequestType.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

// после методов register и refreshEmail дергаем метод verify
// для обновления пароля сначала дергаем reset, а потом change

import Foundation
import Moya

enum AuthRequestType {
    case register(RegisterModel)
    case verify(VerifyModel) // код живет 10 минут
    case login(LoginModel)
    case getUser
    case refreshToken(String)
    case refreshUser(User)
    case refreshEmail(EmailModel)
    case resetPassword(EmailModel)
    case refreshPassword(NewPassword)
    case deleteUser

    private var bearerToken: String {
        return TokenManager.shared.bearerToken
    }
}

extension AuthRequestType: TargetType {

    var baseURL: URL {
        return URL(string: AssetURL.authURL.rawValue)!
    }

    var path: String {
        switch self {
        case .register:
            return "/api/v1/auth/register"
        case .verify:
            return "/api/v1/auth/verify"
        case .login:
            return "/api/v1/auth/login"
        case .getUser, .refreshUser, .deleteUser:
            return "/api/v1/user"
        case .refreshToken:
            return "/api/v1/auth/refresh"
        case .refreshEmail:
            return "/api/v1/user/changeEmail"
        case .resetPassword:
            return "/api/v1/auth/passwordReset"
        case .refreshPassword:
            return "/api/v1/auth/passwordChange"
        }
    }

    var method: Moya.Method {
        switch self {
        case .register, .verify, .login, .refreshToken, .refreshUser,
                .refreshEmail, .resetPassword, .refreshPassword:
            return .post
        case .getUser:
            return .get
        case .deleteUser:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .register(let model):
            return .requestJSONEncodable(model)
        case .verify(let model):
            return .requestJSONEncodable(model)
        case .login(let model):
            return .requestJSONEncodable(model)
        case .getUser:
            return .requestPlain
        case .refreshToken(let token):
            let parameters: [String: Any] = ["refreshToken": "\(token)"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        case .refreshUser(let model):
            return .requestJSONEncodable(model)
        case .refreshEmail(let model), .resetPassword(let model):
            return .requestJSONEncodable(model)
        case .refreshPassword(let model):
            return .requestJSONEncodable(model)
        case .deleteUser:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .register, .verify, .login, .refreshToken, .resetPassword, .refreshPassword:
            return ["Content-Type": "application/json"]
        case .getUser, .deleteUser:
            return ["Authorization" : "Bearer \(bearerToken)"]
        case .refreshUser, .refreshEmail:
            return ["Content-Type": "application/json",
                    "Authorization" : "Bearer \(bearerToken)"
            ]
        }
    }
}
