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

enum TechMarketAPI {
    case productConnection(page: Int, itemsPerPage: Int)
    case productDetail(Int)
}

extension TechMarketAPI: ServerAPI {
    var method: HTTPMethod {
        switch self {
        case .productConnection:
            return .get
        case .productDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .productConnection:
            return "/api/products"
        case .productDetail(let id):
            return "/api/products/\(id)"
        }
    }
    
    var params: [String: String]? {
        switch self {
        case .productConnection(let page, let itemsPerPage):
            return [
                "page_no" : String(page),
                "items_per_page": String(itemsPerPage)
            ]
        case .productDetail:
            return [:]
        }
    }
}
