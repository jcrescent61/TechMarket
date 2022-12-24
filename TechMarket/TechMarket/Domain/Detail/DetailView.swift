//
//  DetailView.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/22.
//

import UIKit

import RxCocoa
import SnapKit
import Then

final class DetailView: UIView {
    private let scrollView = UIScrollView()
    
    lazy var collectionView: UICollectionView = {
        let layout = configureFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let vendorLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .systemGray
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .lightGray
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private let discountPercentageLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = .orange
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private let discountedPriceLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        scrollView.isPagingEnabled = false
        collectionView.register(
            DetailCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailCollectionViewCell.id
        )
        
        addSubviews(
            scrollView
        )
        
        scrollView.addSubviews(
            collectionView,
            vendorLabel,
            titleLabel,
            priceLabel,
            discountPercentageLabel,
            discountedPriceLabel,
            descriptionLabel
        )
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(self.snp.left)
            $0.right.equalTo(self.snp.right)
            $0.height.equalTo(350)
        }
        
        vendorLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().offset(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(vendorLabel.snp.bottom).offset(10)
            $0.left.equalTo(self.snp.left).offset(30)
            $0.right.equalTo(self.snp.right).offset(-30)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
        }
        
        discountPercentageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        discountPercentageLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel.snp.left)
        }
        
        discountedPriceLabel.snp.makeConstraints {
            $0.centerY.equalTo(discountPercentageLabel.snp.centerY)
            $0.left.equalTo(discountPercentageLabel.snp.right).offset(10)
            $0.right.equalTo(titleLabel)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(discountedPriceLabel.snp.bottom).offset(30)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-30)
        }
    }
    
    func configureView(model: Model.ProductDetail) {
        titleLabel.text = model.name
        vendorLabel.text = model.vendors?.name
        descriptionLabel.text = model.description
        configurePrice(
            price: model.price,
            bargainPrice: model.bargainPrice,
            discountedPrice: model.discountedPrice
        )
    }
    
    private func configurePrice(price: Double?, bargainPrice: Double?, discountedPrice: Double?) {
        guard let price = price else { return }
        
        if discountedPrice == 0  {
            discountedPriceLabel.text = String(price)
            discountPercentageLabel.isHidden = true
            priceLabel.isHidden = true
            
            discountedPriceLabel.snp.remakeConstraints {
                $0.top.equalTo(priceLabel.snp.bottom).offset(5)
                $0.left.equalTo(titleLabel.snp.left)
                $0.right.equalTo(titleLabel.snp.right)
            }
            
        } else {
            guard let bargainPrice = bargainPrice, let discountedPrice = discountedPrice else { return }
            let discountedPercentage = discountedPrice / price * 100
            priceLabel.text = String(price)
            discountPercentageLabel.text = String(format: "%.0f", discountedPercentage) + "%"
            discountedPriceLabel.text = String(bargainPrice)
        }
    }
    
    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = TechMarketConstraint.minimumInteritemSpacing
        flowLayout.itemSize.width = TechMarketConstraint.deviceWidth
        flowLayout.itemSize.height = TechMarketConstraint.deviceHeight / 2.5
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
}
