//
//  BaseRouter.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Alamofire
import Foundation

class BaseRouter: APIConfiguration {
    init() {}

    var encoding: ParameterEncoding? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var method: HTTPMethod {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var path: String {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var parameters: Parameters? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var keyPath: String? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var baseURL: URL? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    func asURLRequest() throws -> URLRequest {
        var url = AppSettings.serverUrl
        
        if let _baseURL = baseURL {
            url = _baseURL
        }

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 15

        if let encoding = encoding {
            return try encoding.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}
