//
//  SplashViewController.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
        setupConstraints()
    }
    
    private func setup() {
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "TechMarketLogo")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
