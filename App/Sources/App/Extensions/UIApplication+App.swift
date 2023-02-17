//
//  UIApplication+App.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

extension UIApplication {
  static var keyWindow: UIWindow? {
    return shared
      .connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }
  }
}
