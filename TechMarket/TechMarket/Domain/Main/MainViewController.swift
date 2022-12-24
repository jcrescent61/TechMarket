//
//  MainViewController.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Then

enum TechMarketConstraint {
    static let deviceWidth = UIScreen.main.bounds.width
    static let deviceHeight = UIScreen.main.bounds.height
    static let minimumInteritemSpacing: CGFloat = 1
    static let numberOfCells: CGFloat = 2.5
}

final class MainViewController: UIViewController, UIScrollViewDelegate {
    
    private var mainViewModel: MainViewModelable?
    private lazy var collectionView: UICollectionView = {
        let layout = configureFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let bag = DisposeBag()
    
    static func instance(viewModel: MainViewModelable) -> MainViewController {
        let viewController = MainViewController(nibName: nil, bundle: nil)
        viewController.mainViewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = collectionView
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.id)
        mainViewModel?.input.viewDidLoad()
        setNavigation()
        bind()
    }
    
    private func bind() {
        // MARK: - Input
        collectionView.rx.willDisplayCell
            .subscribe (onNext: { [weak self] (_, indexpath) in
                self?.mainViewModel?.input.updatePageIfNeeded(row: indexpath.item)
            })
            .disposed(by: bag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.mainViewModel?.input.itemSelected(row: item.row)
            })
            .disposed(by: bag)
        
        // MARK: - Output
        mainViewModel?.output.sectionObservable
            .asDriver(onErrorJustReturn: [])
            .drive(self.collectionView.rx.items(dataSource: createDatasource()))
            .disposed(by: bag)
        
        mainViewModel?.output.pushDetailViewObservable
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] productID in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    DetailViewController.instance(
                        viewModel: DetailViewModel(networker: Networker(),
                                                   productID: productID)
                    ), animated: true
                )
            })
            .disposed(by: bag)
    }
    
    private func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.title = "TechMarket"
    }
    
    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = TechMarketConstraint.minimumInteritemSpacing
        flowLayout.itemSize.width = (TechMarketConstraint.deviceWidth
                                     - TechMarketConstraint.minimumInteritemSpacing) / 2
        flowLayout.itemSize.height = TechMarketConstraint.deviceHeight
                                     / TechMarketConstraint.numberOfCells
        return flowLayout
    }
    
    private func createDatasource(
    ) -> RxCollectionViewSectionedReloadDataSource<SectionModel<ProductSection, Model.Product>> {
        return .init { datasource, collectionView, indexPath, item in
            let section = datasource.sectionModels[indexPath.section].identity
            
            switch section {
            case .productResponse:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainViewCell.id,
                    for: indexPath
                ) as? MainViewCell else {
                    return UICollectionViewCell()
                }
                cell.setUpLabel(item: item)
                return cell
            }
        }
    }
}

