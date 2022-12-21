//
//  UIView+.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/19.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
