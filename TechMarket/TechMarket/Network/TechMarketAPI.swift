//
//  TechMarketAPI.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

protocol ServerAPI {
    var method: HTTPMethod { get }
    var path: String { get }
    var params: [String: String]? { get }
}

enum ProductConnectionAPI {
    case productConnection
}

extension ProductConnectionAPI: ServerAPI {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/products"
    }
    
    var params: [String : String]? {
        return [:]
    }
}
