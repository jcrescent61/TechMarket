//
//  ProductResponse.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

extension Model {
    
    struct ProductResponse: Decodable {
        let pageNo: Int?
        let itemsPerPage: Int?
        let totalCount: Int?
        let offset: Int?
        let limit: Int?
        let lastPage: Int?
        let hasNext: Bool?
        let hasPrev: Bool?
        let pages: [Product]
    }
    
    struct Product: Decodable {
        let id: Int?
        let vendorID: Int?
        let vendorName: String?
        let name: String?
        let description: String?
        let thumbnail: String?
        let currency: String?
        let price: Double?
        let bargainPrice: Double?
        let discountedPrice: Double?
        let stock: Int?
        let createdAt: String?
        let issuedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case vendorID = "vendor_id"
            case vendorName
            case name
            case description
            case thumbnail
            case currency
            case price
            case bargainPrice = "bargain_price"
            case discountedPrice = "discounted_price"
            case stock
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}
