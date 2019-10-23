//
//  SceneDelegate.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow()
        window?.windowScene = windowScene

        let rootViewController = ViewControllerAssembly.resolve(type: .search)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
