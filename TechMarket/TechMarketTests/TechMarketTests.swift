//
//  TechMarketTests.swift
//  TechMarketTests
//
//  Created by Ellen J on 2022/12/18.
//

import XCTest

import RxSwift
import RxRelay
import RxDataSources

@testable import TechMarket

final class MockNetworker: Networkerable {
    
    let type: Decodable
    
    init(_ type: Decodable) {
        self.type = type
    }
    
    func request<T>(
        _ api: ServerAPI
    ) -> Single<T> where T : Decodable {
        return Single<T>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "Optional unwrapping failed", code: -999)))
                return Disposables.create()
            }
            single(.success(self.type as! T))
            return Disposables.create()
        }
    }
}

final class TechMarketTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var shopViewModel = ShopViewModel(
        networker: MockNetworker(
            Model.ProductResponse(
                pageNo: nil, itemsPerPage: nil, totalCount: nil, offset: nil, limit: nil, lastPage: nil, hasNext: nil, hasPrev: nil, pages: [.init(
                    id: nil,
                    vendorID: nil,
                    vendorName: nil,
                    name: nil,
                    description: nil,
                    thumbnail: nil,
                    currency: .krw,
                    price: nil,
                    bargainPrice: nil,
                    discountedPrice: nil,
                    stock: nil,
                    createdAt: nil,
                    issuedAt: nil
                )])
        )
    )
    
    func test_viewDidLoad_하면_섹션모델이_방출된다() {
        var result: [SectionModel<ProductSection, Model.Product>] = []
        let expect: [SectionModel<ProductSection, Model.Product>] = [
            .init(model: .productResponse, items: [.init(
                id: nil,
                vendorID: nil,
                vendorName: nil,
                name: nil,
                description: nil,
                thumbnail: nil,
                currency: .krw,
                price: nil,
                bargainPrice: nil,
                discountedPrice: nil,
                stock: nil,
                createdAt: nil,
                issuedAt: nil
            )
            ])
        ]
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        
        // when
        shopViewModel.output.sectionObservable
            .subscribe { section in
                result = section
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        shopViewModel.input.viewDidLoad()
        
        wait(for: [expectation], timeout: 1.0)
        
        // then
        XCTAssertEqual(result, expect)
    }
    
    func test_updatePageIfNeeded_하면_섹션모델이_방출된다() {
        var result: [SectionModel<ProductSection, Model.Product>] = []
        let expect: [SectionModel<ProductSection, Model.Product>] = [
            .init(model: .productResponse, items: [.init(
                id: nil,
                vendorID: nil,
                vendorName: nil,
                name: nil,
                description: nil,
                thumbnail: nil,
                currency: .krw,
                price: nil,
                bargainPrice: nil,
                discountedPrice: nil,
                stock: nil,
                createdAt: nil,
                issuedAt: nil
            )
            ])
        ]
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        
        // when
        shopViewModel.output.sectionObservable
            .subscribe { section in
                result = section
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        shopViewModel.input.updatePageIfNeeded(row: 0)
        wait(for: [expectation], timeout: 1.0)
        
        // then
        XCTAssertEqual(result, expect)
    }
}

extension Model.Product: Equatable {
    public static func == (lhs: Model.Product, rhs: Model.Product) -> Bool {
        return lhs.id == rhs.id &&
        lhs.vendorID == rhs.vendorID &&
        lhs.vendorName == rhs.vendorName &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.thumbnail == rhs.thumbnail &&
        lhs.currency == rhs.currency &&
        lhs.price == rhs.price &&
        lhs.bargainPrice == rhs.bargainPrice &&
        lhs.discountedPrice == rhs.discountedPrice &&
        lhs.stock == rhs.stock &&
        lhs.createdAt == rhs.createdAt &&
        lhs.issuedAt == rhs.issuedAt
    }
}
