//
//  AppDependency.swift
//  TechMarket
//
//  Created by Ellen J on 2022/12/18.
//

import UIKit

final class AppDependency {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

enum CompositionRoot {
    static func resolve(scene: UIWindowScene) -> AppDependency {
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = UINavigationController(
            rootViewController: MainViewController.instance(
                viewModel: MainViewModel(networker: Networker())
            )
        )
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = .light
        return .init(window: window)
    }
}
