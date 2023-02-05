//
//  AppDelegate.swift
//  Lunar
//
//  Created by hbkim on 2023/10/12.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  private(set) lazy var dependency: AppDependency = {
    return CompositionRoot.resolve()
  }()
  
  lazy var window: UIWindow? = dependency.window
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return true
  }
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
