//
//  Double.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/24.
//

import Foundation

extension Double {
    func formatNumber(iso: Model.Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = iso.rawValue
        let number = NSNumber(value: self)
        guard let formattedNumber = formatter.string(from: number) else { return "" }
        return formattedNumber
    }
}
