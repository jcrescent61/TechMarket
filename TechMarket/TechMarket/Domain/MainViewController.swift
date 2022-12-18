//
//  MainViewController.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import UIKit

import RxSwift

final class MainViewController: UIViewController {
    
    private var mainViewModel: MainViewModelable?
    private let disposeBag = DisposeBag()
    
    static func instance(viewModel: MainViewModelable) -> MainViewController {
        let viewController = MainViewController(nibName: nil, bundle: nil)
        viewController.mainViewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        mainViewModel?.input.viewDidLoad()
    }
}

