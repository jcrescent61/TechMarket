//
//  HTTPMethod.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

enum HTTPMethod: String, CustomStringConvertible {
    case get
    case post
    case put
    case delete
    
    var description: String {
        rawValue
    }
}
