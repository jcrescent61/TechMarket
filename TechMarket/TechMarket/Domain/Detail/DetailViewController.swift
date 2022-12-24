//
//  DetailViewController.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/22.
//

import Foundation

import RxSwift
import RxCocoa
import Then
import SnapKit

final class DetailViewController: UIViewController {
    
    private var detailViewModel: DetailViewModelable?
    private let bag = DisposeBag()
    private let detailView = DetailView(frame: .zero)
    
    static func instance(viewModel: DetailViewModelable) -> DetailViewController {
        let viewController = DetailViewController(nibName: nil, bundle: nil)
        viewController.detailViewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        detailViewModel?.input.viewDidLoad()
        bind()
    }
    
    private func bind() {
        detailViewModel?.output.productObservable
            .asDriver(
                onErrorJustReturn: .init(
                    ProductDetailComponent()
                )
            )
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                self.detailView.configureView(model: model)
            })
            .disposed(by: bag)
        
        detailViewModel?.output.productObservable
            .map { $0.images ?? [] }
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.detailView.collectionView.rx.items(
                    cellIdentifier: DetailCollectionViewCell.id,
                    cellType: DetailCollectionViewCell.self
                )
            ) { indexPath, image, cell in
                cell.configureCell(images: image)
            }
            .disposed(by: bag)
    }
}
