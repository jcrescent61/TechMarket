//
//  MainViewCell.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/19.
//

import UIKit

import SnapKit
import Then

final class MainViewCell: UICollectionViewCell {
    static let id: String = "\(MainViewCell.self)"
    
    private let thumbnailImage = UIImageView().then {
        $0.image = UIImage(systemName: "questionmark.square.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let currencyLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let priceLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let stockLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
}

extension MainViewCell {
    func setUpLabel(product: Model.Product) {
        thumbnailImage.loadImage(from: product.thumbnail)
        titleLabel.text = product.name
        priceLabel.text = product.price?.formatNumber(iso: product.currency)
        stockLabel.text = String(describing: product.stock)
    }
    
    private func setUpUI() {
        backgroundColor = .white
        
        addSubviews(
            thumbnailImage,
            titleLabel,
            priceLabel
        )
        
        // MARK: - thumbnailImage
        thumbnailImage.snp.makeConstraints {
            $0.top.left.right.width.equalToSuperview()
            $0.height.equalTo(thumbnailImage.snp.width)
        }
        
        // MARK: - titleLabel
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        // MARK: - priceLabel
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }
}
