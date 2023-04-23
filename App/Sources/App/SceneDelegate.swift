//
//  SceneDelegate.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var coordinator: AppCoordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    coordinator = AppCoordinator(
      window: UIWindow(windowScene: windowScene).apply {
        $0.backgroundColor = .white
        $0.makeKeyAndVisible()
      },
      navigationController: UINavigationController()
    )
    coordinator?.start()
  }
}
