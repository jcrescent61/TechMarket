//
//  TabBarViewController.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    fileprivate static var tabBarItemWidth: CGFloat {
        return UIScreen.main.bounds.size.width / 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewController()
        view.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .systemGray2
        tabBar.backgroundColor = .systemGray6
    }
    
    private func setTabBarViewController() {
        let homeViewController = UIViewController()
        homeViewController.tabBarItem.image = UIImage(systemName: "house")
        homeViewController.tabBarItem.title = "HOME"
        
        let productViewController = UINavigationController(
            rootViewController: ShopViewController.instance(
                viewModel: ShopViewModel(networker: Networker())
            )
        )
        productViewController.tabBarItem.image = UIImage(systemName: "bag")
        productViewController.tabBarItem.title = "SHOP"

        let profileViewController = UIViewController()
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.title = "ACTIVE"
        
        let settingViewController = UIViewController()
        settingViewController.tabBarItem.image = UIImage(systemName: "line.3.horizontal")
        settingViewController.tabBarItem.title = "SETTING"
        
        viewControllers = [
            homeViewController,
            productViewController,
            profileViewController,
            settingViewController
        ]
    }
}
