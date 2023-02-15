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

protocol ShopViewModelInputInterface {
    func viewDidLoad()
    func updatePageIfNeeded(row: Int)
    func itemSelected(row: Int)
    func searchProduct(text: String)
    func tapCancelButton()
}

protocol ShopViewModelOutputInterface {
    var sectionObservable: Observable<[SectionModel<ProductSection, Model.Product>]> { get }
    
    var pushDetailViewObservable: Observable<Int> { get }
}

protocol ShopViewModelable {
    var input: ShopViewModelInputInterface { get }
    var output: ShopViewModelOutputInterface { get }
}

enum ProductSection {
    case productResponse
}

final class ShopViewModel: ShopViewModelable {
    var input: ShopViewModelInputInterface { self }
    var output: ShopViewModelOutputInterface { self }
    
    private let bag = DisposeBag()
    private let networker: Networkerable
    private var products: [Model.Product] = []
    private var searchText = ""
    private var currentPage = 1
    private let itemsPerPage = 10
    private var hasNextPage = true
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let sectionRelay = PublishRelay<[SectionModel<ProductSection, Model.Product>]>()
    private let pushDetailViewRelay = PublishRelay<Int>()
    private var isRequest = false
    
    init(
        networker: Networkerable
    ) {
        self.networker = networker
    }
    
    private func fetchProducts(searchText: String) {
        guard isRequest == false else { return }
        isRequest = true
        
        networker.request(
            TechMarketAPI.productConnection(
                page: currentPage,
                itemsPerPage: itemsPerPage,
                searchValue: searchText
            )
        )
        .subscribe(onSuccess: { [weak self] (model: Model.ProductResponse) in
            guard let self = self else { return }
            self.products.append(contentsOf: model.pages)
            self.sectionRelay.accept(
                [.init(model: .productResponse, items: self.products)]
            )
        }, onFailure: { [weak self] error in
            guard let self = self else { return }
            self.products = []
            self.sectionRelay.accept([])
            print("error \(error)")
        }, onDisposed: { [weak self] in
            guard let self = self else { return }
            self.isRequest = false
        })
        .disposed(by: bag)
    }
}

extension ShopViewModel: ShopViewModelInputInterface {
    func viewDidLoad() {
        fetchProducts(searchText: searchText)
    }
    
    func updatePageIfNeeded(row: Int) {
        if hasNextPage && self.products.count - 1 <= row {
            fetchProducts(searchText: searchText)
        }
    }
    
    func itemSelected(row: Int) {
        guard let id = products[row].id else { return }
        pushDetailViewRelay.accept(id)
    }
    
    func searchProduct(text: String) {
        self.products = []
        self.currentPage = 1
        searchText = text
        fetchProducts(searchText: searchText)
    }
    
    func tapCancelButton() {
        self.products = []
        self.currentPage = 1
        searchText = ""
        fetchProducts(searchText: searchText)
    }
}

extension ShopViewModel: ShopViewModelOutputInterface {
    var sectionObservable: Observable<[SectionModel<ProductSection, Model.Product>]> {
        return sectionRelay.asObservable()
    }
    
    var pushDetailViewObservable: Observable<Int> {
        return pushDetailViewRelay.asObservable()
    }
}
