//
//  DetailViewModel.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/22.
//

import Foundation

import RxSwift
import RxRelay
import RxDataSources

protocol DetailViewModelInputInterface {
    func viewDidLoad()
}

protocol DetailViewModelOutputInterface {
    var productObservable: Observable<Model.ProductDetail> { get }
}

protocol DetailViewModelable {
    var input: DetailViewModelInputInterface { get }
    var output: DetailViewModelOutputInterface { get }
}

final class DetailViewModel: DetailViewModelable {
    var input: DetailViewModelInputInterface { self }
    var output: DetailViewModelOutputInterface { self }
    
    private let bag = DisposeBag()
    private let networker: Networkerable
    private let productID: Int
    private var product: Model.ProductDetail?
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var productRelay = PublishRelay<Model.ProductDetail>()
    
    init(
        networker: Networkerable,
        productID: Int
    ) {
        self.networker = networker
        self.productID = productID
    }
    
    private func fetchDetailProduct() {
        networker.request(
            TechMarketAPI.productDetail(productID)
        )
        .subscribe(onSuccess: { [weak self] (model: Model.ProductDetail) in
            guard let self = self else { return }
            self.product = model
            guard let product = self.product else { return }
            self.productRelay.accept(product)
        }, onFailure: { error in
            print("error \(error)")
        })
        .disposed(by: bag)
    }
}

extension DetailViewModel: DetailViewModelInputInterface {
    func viewDidLoad() {
        fetchDetailProduct()
    }
}

extension DetailViewModel: DetailViewModelOutputInterface {
    var productObservable: Observable<Model.ProductDetail> {
        return productRelay.asObservable()
    }
}
