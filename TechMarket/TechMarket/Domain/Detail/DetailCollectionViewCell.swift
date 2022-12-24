//
//  DetailCollectionViewCell.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/23.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    static let id = "\(DetailCollectionViewCell.self)"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func configureCell(
        images: Model.ProductImage
    ) {
        imageView.loadImage(from: images.thumbnailUrl)
    }
}
