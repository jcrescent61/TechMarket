//
//  MainViewModel.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import Foundation

import RxSwift
import RxRelay
import RxDataSources

protocol MainViewModelInputInterface {
    func viewDidLoad()
    func updatePageIfNeeded(row: Int)
}

protocol MainViewModelOutputInterface {
    var sectionObservable: Observable<[SectionModel<ProductSection, Model.Product>]> { get }
}

protocol MainViewModelable {
    var input: MainViewModelInputInterface { get }
    var output: MainViewModelOutputInterface { get }
}

enum ProductSection {
    case productResponse
}

final class MainViewModel: MainViewModelable {
    var input: MainViewModelInputInterface { self }
    var output: MainViewModelOutputInterface { self }
    
    private let bag = DisposeBag()
    private let networker: Networkerable
    private var products: [Model.Product] = []
    private var currentPage = 1
    private let itemsPerPage = 10
    private var hasNextPage = false
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let sectionRelay = PublishRelay<[SectionModel<ProductSection, Model.Product>]>()
    
    init(
        networker: Networkerable
    ) {
        self.networker = networker
    }
    
    private func fetchProducts() {
        networker.request(
            ProductConnectionAPI.productConnection,
            params: [
                "page_no" : currentPage,
                "items_per_page": itemsPerPage
            ]
        )
        .debug()
        .subscribe { [weak self] (result: Result<Model.ProductResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.currentPage += 1
                self.products.append(contentsOf: model.pages)
                if let hasNextPage = model.hasNext {
                    self.hasNextPage = hasNextPage
                }
                self.sectionRelay.accept([.init(model: .productResponse, items: self.products)])
            case .failure(let error):
                print("error \(error)")
            }
        }
        .disposed(by: bag)
    }
}

extension MainViewModel: MainViewModelInputInterface {
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
        fetchProducts()
    }
    
    func updatePageIfNeeded(row: Int) {
        if self.products.count - 1 == row {
            fetchProducts()
        }
    }
}

extension MainViewModel: MainViewModelOutputInterface {
    var sectionObservable: Observable<[SectionModel<ProductSection, Model.Product>]> {
        return sectionRelay.asObservable()
    }
}
