//
//  ProductDetail.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/22.
//

import Foundation

extension Model {
    struct ProductDetail: Decodable {
        let id: Int?
        let vendorID: Int?
        let name: String?
        let description: String?
        let thumbnail: String?
        let currency: Currency?
        let price: Double?
        let bargainPrice: Double?
        let discountedPrice: Double?
        let stock: Int?
        let images: [ProductImage]?
        let vendors: Vendor?
        let createdAt: String?
        let issuedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case vendorID = "vendor_id"
            case name
            case description
            case thumbnail
            case currency
            case price
            case bargainPrice = "bargain_price"
            case discountedPrice = "discounted_price"
            case stock
            case images
            case vendors
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
        
        init(_ component: ProductDetailComponent) {
            self.id = component.id
            self.vendorID = component.vendorID
            self.name = component.name
            self.description = component.description
            self.thumbnail = component.thumbnail
            self.currency = component.currency
            self.price = component.price
            self.bargainPrice = component.bargainPrice
            self.discountedPrice = component.discountedPrice
            self.stock = component.stock
            self.images = component.images
            self.vendors = component.vendors
            self.createdAt = component.createdAt
            self.issuedAt = component.issuedAt
        }
    }
    
    struct Vendor: Decodable {
        let id: Int?
        let name: String?
    }
    
    struct ProductImage: Decodable {
        let id: Int?
        let url: String?
        let thumbnailUrl: String?
        let issuedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case url
            case thumbnailUrl = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }
}

struct ProductDetailComponent {
    let id: Int? = nil
    let vendorID: Int? = nil
    let name: String? = nil
    let description: String? = nil
    let thumbnail: String? = nil
    let currency: Model.Currency? = nil
    let price: Double? = nil
    let bargainPrice: Double? = nil
    let discountedPrice: Double? = nil
    let stock: Int? = nil
    let images: [Model.ProductImage]? = nil
    let vendors: Model.Vendor? = nil
    let createdAt: String? = nil
    let issuedAt: String? = nil
}
