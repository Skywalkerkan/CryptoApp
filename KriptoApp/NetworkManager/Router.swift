//
//  Router.swift
//  KriptoApp
//
//  Created by Erkan on 1.05.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case allCrpytos
    
    var method: HTTPMethod {
        switch self {
        case .allCrpytos:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .allCrpytos:
            return nil
        }
    }
    
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var url: URL {
        switch self {
        case .allCrpytos:
            let url = URL(string: Constants.cryptoUrl)
            return url!
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
