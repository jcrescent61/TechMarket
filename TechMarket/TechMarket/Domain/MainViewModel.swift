//
//  MainViewModel.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

import RxSwift
import RxRelay

protocol MainViewModelInputInterface {
    func viewDidLoad()
}

protocol MainViewModelOutputInterface {
    
}

protocol MainViewModelable {
    var input: MainViewModelInputInterface { get }
    var output: MainViewModelOutputInterface { get }
}

final class MainViewModel: MainViewModelable {
    var input: MainViewModelInputInterface { self }
    var output: MainViewModelOutputInterface { self }
    
    private let bag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
}

extension MainViewModel: MainViewModelInputInterface {
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
        print("wow")
    }
}

extension MainViewModel: MainViewModelOutputInterface {
    
}
